//
//  TrendingMoviesViewModel.swift
//  TrendingMoviesModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
import CoreModule
import Combine
import CoreData



import Foundation
import Combine

public class TrendingMoviesViewModel: ObservableObject {
    @Published var movies = [Movie]() // Filtered movies
    @Published var allMovies = [Movie]() // Unfiltered movies
    @Published var genres = [Genre]()

    @Published var selectedGenre: Genre? {
        didSet {
            Task {
                await filterMovies()
            }
        }
    }
    @Published var searchText: String = "" {
        didSet {
            Task {
                await filterMovies()
            }
        }
    }
    @Published var isLoading: Bool = false
// public to check from mock file (unit test)
    public var currentPage = 1
    public var totalPages = 1
    public var cancellables = Set<AnyCancellable>()

    private let repository: TrendingMoviesRepositoryProtocol

    public init(repository: TrendingMoviesRepositoryProtocol = TrendingMoviesRepository()) {
        self.repository = repository

        // Start fetching once the network status is known
        NetworkManager.shared.$isOnline
            .sink { [weak self] isOnline in
                guard let self = self else { return }
                if isOnline {
                    // If online, fetch genres and trending movies
                    self.fetchGenres()
                    self.fetchTrendingMovies()
                } else {
                    // If offline, load from CoreData
                    self.genres = CoreDataManager.shared.fetchGenres()
                    self.allMovies = CoreDataManager.shared.fetchMovies()
                }
            }
            .store(in: &cancellables)
    }

    func resetPagination() {
        currentPage = 1
        totalPages = 1
        allMovies = []
        movies = []
    }


    func fetchGenres() {
        print(NetworkManager.shared.isOnline)
        if NetworkManager.shared.isOnline {
            repository.fetchGenres()
                .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    let genres = response.genres ?? []
                    CoreDataManager.shared.saveGenres(genres) // Save genres to CoreData
                    DispatchQueue.main.async {
                        self.genres = genres // Update UI with the latest genres
                    }
                })
                .store(in: &cancellables)
        } else {
            // Offline: Fetch genres from CoreData
            DispatchQueue.main.async {
                self.genres = CoreDataManager.shared.fetchGenres()
            }
        }
    }

    func fetchTrendingMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        if NetworkManager.shared.isOnline {
            repository.fetchTrendingMovies(page: currentPage)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        print("Error fetching movies: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            // Fallback to CoreData if an error occurs
                            self.allMovies = CoreDataManager.shared.fetchMovies()
                        }
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    let movies = response.results
                    CoreDataManager.shared.saveMovies(movies) // Save movies to CoreData
                    DispatchQueue.main.async {
                        self.allMovies.append(contentsOf: movies)
                        self.totalPages = response.totalPages ?? 1
                        Task {
                            await self.filterMovies()
                        }
                    }
                })
                .store(in: &cancellables)
        } else {
            // Offline: Fetch movies from CoreData
            DispatchQueue.main.async {
                self.isLoading = false
                self.allMovies = CoreDataManager.shared.fetchMovies()
            }
        }
    }

    func loadMore() {
        guard !isLoading, currentPage < totalPages else { return }
        currentPage += 1
        fetchTrendingMovies()
    }
    
    @MainActor
    func filterMovies() async {
        movies = allMovies.filter { movie in
            let matchesGenre = selectedGenre == nil || (movie.genreIDs?.contains(selectedGenre!.id) ?? false)
            let matchesSearch = searchText.isEmpty || (movie.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            return matchesGenre && matchesSearch
        }
    }
}

