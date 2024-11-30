//
//  TrendingMoviesRepository.swift
//  TrendingMoviesModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
import Combine
import CoreModule


public protocol TrendingMoviesRepositoryProtocol {
    func fetchGenres() -> AnyPublisher<GenreListResponse, Error>
    func fetchTrendingMovies(page: Int) -> AnyPublisher<MovieListResponse, Error>
}


public final class TrendingMoviesRepository: TrendingMoviesRepositoryProtocol {
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    public func fetchGenres() -> AnyPublisher<GenreListResponse, Error> {
        networkManager.fetch("genre/movie/list?language=en")
    }
    
    public func fetchTrendingMovies(page: Int) -> AnyPublisher<MovieListResponse, Error> {
        let url = "discover/movie?include_adult=false&sort_by=popularity.desc&page=\(page)"
        return networkManager.fetch(url)
    }
    
}
