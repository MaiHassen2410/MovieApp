//
//  TrendingMoviesModuleTests.swift
//  TrendingMoviesModuleTests
//
//  Created by Mai Hassen on 30/11/2024.
//

import XCTest
import Combine
@testable import TrendingMoviesModule


final class TrendingMoviesModuleTests: XCTestCase {
    
    var viewModel: TrendingMoviesViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = TrendingMoviesViewModel(repository: MockTrendingMoviesRepository())
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    func testFetchGenres() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch genres")
        
        // When
        viewModel.$genres
            .dropFirst() // Skip the initial empty value
            .sink { genres in
                // Then
                XCTAssertEqual(genres, mockGenres)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchGenres()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
   

    func testFilterMoviesByGenre() async {
        // Given
        viewModel.allMovies = mockMovies
        viewModel.selectedGenre = mockGenres.first(where: { $0.id == 1 })

        // When
        await viewModel.filterMovies()

        // Then
        XCTAssertEqual(viewModel.movies, mockMovies.filter { $0.genreIDs?.contains(1) == true })
    }
 
    func testFilterMoviesBySearchText() async {
        // Given
        viewModel.allMovies = mockMovies
        viewModel.searchText = "Movie 1"

        // When
        await viewModel.filterMovies()

        // Then
        XCTAssertEqual(viewModel.movies, mockMovies.filter { $0.title?.localizedCaseInsensitiveContains("Movie 1") == true })
    }
    
    func testLoadMoreMovies() {
        // Given
        viewModel.allMovies = mockMovies
        viewModel.totalPages = 2
        viewModel.currentPage = 1

        let expectation = XCTestExpectation(description: "Load more movies")

        // When
        viewModel.$allMovies
            .dropFirst()
            .sink { movies in
                // Then
                XCTAssertEqual(movies, mockMovies + mockMovies) // Mock data returns the same movies for page 2
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMore()

        wait(for: [expectation], timeout: 1.0)
    }

    
    
}



