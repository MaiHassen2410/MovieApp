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



let mockMovies: [Movie] = [
    Movie(id: 1, title: "Movie 1", posterPath: "/path1.jpg", releaseDate: "2024-01-01", genreIDs: [1, 2], overview: "Overview of Movie 1"),
    Movie(id: 2, title: "Movie 2", posterPath: "/path2.jpg", releaseDate: "2024-02-01", genreIDs: [2, 3], overview: "Overview of Movie 2"),
    Movie(id: 3, title: "Movie 3", posterPath: "/path3.jpg", releaseDate: "2024-03-01", genreIDs: [1], overview: "Overview of Movie 3"),
]

let mockGenres: [Genre] = [
    Genre(id: 1, name: "Action"),
    Genre(id: 2, name: "Comedy"),
    Genre(id: 3, name: "Drama")
]

let mockMovieListResponse = MovieListResponse(page: 1, results: mockMovies, totalResults: 3, totalPages: 1)
let mockGenreListResponse = GenreListResponse(genres: mockGenres)


class MockTrendingMoviesRepository: TrendingMoviesRepositoryProtocol {
    
    func fetchGenres() -> AnyPublisher<GenreListResponse, Error> {
        
        Just(mockGenreListResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchTrendingMovies(page: Int) -> AnyPublisher<MovieListResponse, Error> {
        print("MockTrendingMoviesRepository returning: \(mockMovieListResponse.results)")

       return Just(mockMovieListResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
