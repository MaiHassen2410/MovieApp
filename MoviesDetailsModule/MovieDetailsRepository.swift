//
//  MovieDetailsRepository.swift
//  MoviesDetailsModule
//
//  Created by Mai Hassen on 01/12/2024.
//

import Foundation
import Combine
import CoreModule

public protocol MovieDetailsRepositoryProtocol {
    func fetchMovieDetails(movieID: Int) -> AnyPublisher<MovieDetails, Error>
}

public class MovieDetailsRepository: MovieDetailsRepositoryProtocol {
    private let networkManager: NetworkManager

    public init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    public func fetchMovieDetails(movieID: Int) -> AnyPublisher<MovieDetails, Error> {
        let url = "movie/\(movieID)?language=en-US"
        return networkManager.fetch(url)
            .eraseToAnyPublisher()
    }
}
