//
//  MockMovieDetailsRepository.swift
//  MoviesDetailsModuleTests
//
//  Created by Mai Hassen on 02/12/2024.
//

import Foundation
import CoreModule
import MoviesDetailsModule
import Combine

let mockSpokenLanguages = [
    SpokenLanguage(name: "English"),
    SpokenLanguage(name: "French")
]

let mockGenres = [
    Genre(id: 1, name: "Action"),
    Genre(id: 2, name: "Drama")
]

let mockMovieDetails = MovieDetails(
    title: "Mock Movie",
    overview: "This is a mock movie.",
    homepage: "https://mockmovie.com",
    budget: 100000000,
    revenue: 200000000,
    spokenLanguages: mockSpokenLanguages,
    status: "Released",
    runtime: 120,
    posterPath: "/mockposter.jpg",
    releaseDate: "2023-01-01",
    genres: mockGenres
)

class MockMovieDetailsRepository: MovieDetailsRepositoryProtocol {
    var shouldReturnError = false

    func fetchMovieDetails(movieID: Int) -> AnyPublisher<MovieDetails, Error> {
        if shouldReturnError {
            print("Mock repository returning error") // Debug logging
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        } else {
            print("Mock repository returning success") // Debug logging
            return Just(mockMovieDetails)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }


}
