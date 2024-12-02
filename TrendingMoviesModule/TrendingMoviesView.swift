//
//  TrendingMoviesView.swift
//  TrendingMoviesModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import SwiftUI
import CoreModule
import MoviesDetailsModule



public struct TrendingMoviesView: View {
    @StateObject var viewModel: TrendingMoviesViewModel
    @State private var scrollToTopID = UUID()
    public init(viewModel: TrendingMoviesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Search Bar
                searchBar
        
                // Title Section
                titleSectionView
                
                // Genre Chips
                genreView

                // Movie Grid with LazyVGrid
                movieList
            }
            .padding(.top, 20)
        }
        .onAppear {
            // Prevent fetching if movies are already populated
            if viewModel.movies.isEmpty {
                viewModel.fetchTrendingMovies()
            }
        }
    }
    
    // Search Bar View
    var searchBar: some View {
        HStack {
            ZStack(alignment: .leading) {
                if viewModel.searchText.isEmpty {
                    Text("Search TMDB")
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
                TextField("", text: $viewModel.searchText)
                    .padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 10)
            }
        }
        .padding(.horizontal)
        .background(Color.black)
    }
    
    // Title Section View
    var titleSectionView: some View {
        HStack {
            Text("Watch New Movies")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
                .padding(.leading)
            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color.black)
    }
    
    // Genre View
    var genreView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Add a default "All" option to clear genre selection
                Text("All")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .foregroundColor(viewModel.selectedGenre == nil ? .black : .white)
                    .background(viewModel.selectedGenre == nil ? Color.yellow : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.yellow, lineWidth: 2)
                    )
                    .cornerRadius(16)
                    .onTapGesture {
                        
                        viewModel.selectedGenre = nil
                        scrollToTopID = UUID()
                    }
                
                ForEach(viewModel.genres) { genre in
                    Text(genre.name ?? "")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .foregroundColor(viewModel.selectedGenre == genre ? .black : .white)
                        .background(viewModel.selectedGenre == genre ? Color.yellow : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.yellow, lineWidth: 2)
                        )
                        .cornerRadius(16)
                        .onTapGesture {
                            
                            viewModel.selectedGenre = genre
                            scrollToTopID = UUID()
                        }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.black)
        }
    }
    
    var offlineBanner: some View {
        VStack {
            if !NetworkManager.shared.isOnline {
                Text("You are currently offline. Details are unavailable.")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding()
            }
        }
    }
    
    
    // Movie list view
    var movieList: some View {
        ScrollViewReader { proxy in
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.movies) { movie in
                    movieRow(for: movie)
                
                    
                    
                    .onAppear() {
                        if movie == viewModel.movies.last && !viewModel.isLoading  {
                            viewModel.loadMore()
                        }
                    }
                }
                
                
                // Loading indicator for the first page only
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }
            }
            .padding(.horizontal)
            .id(scrollToTopID) // Assign the scrollToTopID here
                           }
                           .onChange(of: scrollToTopID) { _, _ in
                               withAnimation {
                                   proxy.scrollTo(scrollToTopID, anchor: .top) // Scroll to the top
                               }
                           }
        }
        .background(Color.black)
    }
    private func movieRow(for movie: Movie) -> some View {
        VStack {
            if NetworkManager.shared.isOnline {
                NavigationLink(destination: MovieDetailsView(movieID: movie.id)) {
                    MovieItem(movie: movie)
                }
            } else {
                MovieItem(movie: movie)
                               .opacity(0.5) // Dim the item to indicate it's not clickable
            }
        }
        .padding(.bottom, 8) // Optional: add some bottom padding for spacing
    }
}




public struct MovieItem: View {
    var movie: Movie
    @StateObject private var imageLoader = ImageLoader()

    public init(movie: Movie) {
        self.movie = movie
    }

    public var body: some View {
        VStack {
            if let image = imageLoader.image {
                // Display the cached or loaded image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                // Placeholder while loading
                Color.gray
                    .frame(height: 200) // Adjust size
                    .cornerRadius(10)
            }

            // Movie Title
            Text(movie.title ?? "Unknown Title")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .padding(.top, 5)

            // Movie Release Year
            if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                Text(String(releaseDate.prefix(4))) // Extract year from release date
                    .font(.subheadline)
                    .foregroundColor(.gray)
            } else {
                Text("N/A")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .onAppear {
            if let posterPath = movie.posterPath, !posterPath.isEmpty {
                let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                imageLoader.loadImage(from: imageUrl!)
            } else {
                print("No poster path for this movie.")
            }
        }
        .onDisappear {
            imageLoader.cancel()
        }
    }
}
