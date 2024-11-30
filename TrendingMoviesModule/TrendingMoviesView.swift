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
    // Movie list view
    var movieList: some View {
        ScrollViewReader { proxy in
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(viewModel.movies) { movie in
                    MovieItem(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last && !viewModel.isLoading {
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
}



public struct MovieItem: View {
    var movie: Movie
    
    public init(movie: Movie) {
        self.movie = movie
    }
    public var body: some View {
        VStack {
                   // Movie Poster
                   AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                       image
                           .resizable()
                           .scaledToFill()
                   } placeholder: {
                       // Placeholder if the image is loading
                       Color.gray
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 200) // Adjust size
                   .cornerRadius(10)

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
        
    }
    
}

