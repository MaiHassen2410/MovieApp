//
//  MovieDetailsView.swift
//  MoviesDetailsModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import SwiftUI
import CoreModule


public struct MovieDetailsView: View {
    
    @State private var scrollOffset: CGFloat = 0
    @StateObject private var viewModel: MovieDetailsViewModel
    private let movieID: Int
    
    public init(movieID: Int) {
        self.movieID = movieID
        let repository = MovieDetailsRepository()
        _viewModel = StateObject(wrappedValue: MovieDetailsViewModel(repository: repository))
    }
    
    public var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView {
                    GeometryReader { geo in
                        Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                    }
                    .frame(height: 0)
                    
                    VStack(spacing: 16) {
                        // Full-width movie poster
                        if let posterPath = viewModel.movie?.posterPath {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: UIScreen.main.bounds.width, height: 300)
                            .clipped()
                        }
                        
                        // Title, poster, and release info section
                        HStack(alignment: .top, spacing: 16) {
                            // Smaller poster on the left
                            if let posterPath = viewModel.movie?.posterPath {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 90, height: 135)
                                .cornerRadius(8)
                            }
                            
                            // Title and release info
                            titleAndReleaseDateView
                            Spacer()
                        }
                        
                        .padding(.horizontal)
                        
                        // Overview
                        if let overview = viewModel.movie?.overview {
                            Text(overview)
                                .font(.body)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }
                        
                        // Additional details (Homepage, Languages, Status & Runtime, Budget & Revenue)
                        VStack(alignment: .leading, spacing: 12) {
                            
                            homePageView
                            
                            languageView
                            
                            statusAndRunTimeView
                            
                            budgetAvdRevenuView
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .onAppear {
                    viewModel.fetchMovieDetails(movieID: movieID)
                    setNavigationBarAppearance()
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation {
                        scrollOffset = value
                    }
                }
            }
        }
    }
    
    var budgetAvdRevenuView : some View {
        HStack {
            if let budget = viewModel.movie?.budget {
                Text("Budget:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("$\(budget.formattedWithCommas())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let revenue = viewModel.movie?.revenue {
                Text("Revenue:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("$\(revenue.formattedWithCommas())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        
    }
    
    var statusAndRunTimeView: some View {
        HStack {
            if let status = viewModel.movie?.status {
                Text("Status:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(status)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if let runtime = viewModel.movie?.runtime {
                Text("Runtime:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("\(runtime) min")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var languageView: some View{
        HStack {
            if let languages = viewModel.movie?.spokenLanguages {
                Text("Languages:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(languages.map {$0.name}.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var homePageView: some View{
        HStack {
        if let homepage = viewModel.movie?.homepage, !homepage.isEmpty {
         
                Text("Homepage:")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Link(homepage, destination: URL(string: homepage)!)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
    var titleAndReleaseDateView: some View{
        VStack(alignment: .leading, spacing: 8) {
            Text("\(viewModel.movie?.title ?? "Unknown Title") (\(viewModel.movie?.releaseDate.prefix(4) ?? "N/A"))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
            
            if let genres = viewModel.movie?.genres {
                Text(genres.map { $0.name ?? "" }.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
    

    /// Function to set the navigation bar appearance to black
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }



//Preference key for tracking scroll offset
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}



