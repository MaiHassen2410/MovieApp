//
//  MovieDetailsViewModel.swift
//  MoviesDetailsModule
//
//  Created by Mai Hassen on 01/12/2024.
//


import Foundation
import Combine
import CoreModule



class MovieDetailsViewModel: ObservableObject {
    @Published var movie: MovieDetails?

    private let repository: MovieDetailsRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: MovieDetailsRepositoryProtocol) {
        self.repository = repository
    }

    func fetchMovieDetails(movieID: Int) {
        repository.fetchMovieDetails(movieID: movieID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching movie details: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] movieDetails in
                self?.movie = movieDetails
            })
            .store(in: &cancellables)
    }
}
