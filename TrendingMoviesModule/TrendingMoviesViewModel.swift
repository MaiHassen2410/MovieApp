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
    private var cancellables = Set<AnyCancellable>()

    private let repository: TrendingMoviesRepositoryProtocol

    public init(repository: TrendingMoviesRepositoryProtocol = TrendingMoviesRepository()) {
        self.repository = repository
        fetchGenres()
        fetchTrendingMovies()
    }

    func resetPagination() {
        currentPage = 1
        totalPages = 1
        allMovies = []
        movies = []
    }


    func fetchGenres() {
        repository.fetchGenres()
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] response in
                DispatchQueue.main.async {
                    self?.genres = response.genres ?? []
                }
            })
            .store(in: &cancellables)
    }

    func fetchTrendingMovies() {
        guard !isLoading, currentPage <= totalPages else { return }
        isLoading = true
        
            repository.fetchTrendingMovies(page: currentPage)
                .sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        print("Error fetching movies: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.allMovies.append(contentsOf: response.results)
                    self.totalPages = response.totalPages ?? 0
                    Task {
                        await self.filterMovies()
                    }
                })
                .store(in: &cancellables)
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

