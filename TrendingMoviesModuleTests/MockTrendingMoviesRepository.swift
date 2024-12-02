//
//  MockTrendingMoviesRepository.swift
//  TrendingMoviesModuleTests
//
//  Created by Mai Hassen on 01/12/2024.
//

import Foundation
import Combine
import TrendingMoviesModule
import CoreModule



// Mock Movies
let mockMovies = [
    Movie(id: 1, title: "Movie 1", posterPath: "/path/to/poster1.jpg", releaseDate: "2023-01-01", genreIDs: [1, 2], overview: "Overview of Movie 1"),
    Movie(id: 2, title: "Movie 2", posterPath: "/path/to/poster2.jpg", releaseDate: "2023-01-02", genreIDs: [2, 3], overview: "Overview of Movie 2"),
    Movie(id: 3, title: "Movie 3", posterPath: "/path/to/poster3.jpg", releaseDate: "2023-01-03", genreIDs: [1, 3], overview: "Overview of Movie 3"),
]


// Mock Genres
let mockGenres = [
    Genre(id: 1, name: "Action"),
    Genre(id: 2, name: "Comedy"),
    Genre(id: 3, name: "Drama")
]


// Mock Responses
let mockGenreListResponse = GenreListResponse(genres: mockGenres)

let mockMovieListResponse = MovieListResponse(
    page: 1,
    results: mockMovies,
    totalResults: 3,
    totalPages: 1
)




class MockTrendingMoviesRepository: TrendingMoviesRepositoryProtocol {
    
    func fetchGenres() -> AnyPublisher<GenreListResponse, Error> {
        // Return mock genre list
        return Just(mockGenreListResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchTrendingMovies(page: Int) -> AnyPublisher<MovieListResponse, Error> {
        // Return mock movie list
        return Just(mockMovieListResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
