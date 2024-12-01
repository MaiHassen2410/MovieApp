//
//  MoviesDetailsModuleTests.swift
//  MoviesDetailsModuleTests
//
//  Created by Mai Hassen on 30/11/2024.
//

import XCTest
@testable import MoviesDetailsModule
import Combine

final class MovieDetailsViewModelTests: XCTestCase {
        private var viewModel: MovieDetailsViewModel!
        private var mockRepository: MockMovieDetailsRepository!
        private var cancellables: Set<AnyCancellable>!

        override func setUp() {
            super.setUp()
            mockRepository = MockMovieDetailsRepository()
            viewModel = MovieDetailsViewModel(repository: mockRepository)
            cancellables = []
        }

        override func tearDown() {
            viewModel = nil
            mockRepository = nil
            cancellables = nil
            super.tearDown()
        }

        func testFetchMovieDetailsSuccess() {
            // Given
            let expectation = XCTestExpectation(description: "Fetch movie details")
            
            // When
            viewModel.$movie
                .dropFirst()
                .sink { movie in
                    // Then
                    XCTAssertNotNil(movie)
                    XCTAssertEqual(movie?.title, mockMovieDetails.title)
                    XCTAssertEqual(movie?.overview, mockMovieDetails.overview)
                    XCTAssertEqual(movie?.budget, mockMovieDetails.budget)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            viewModel.fetchMovieDetails(movieID: 1)

            wait(for: [expectation], timeout: 1.0)
        }

    func testFetchMovieDetailsFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Handle movie details fetch failure")
        mockRepository.shouldReturnError = true

        // When
        viewModel.fetchMovieDetails(movieID: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Then
            XCTAssertNil(self.viewModel.movie, "Movie should be nil on failure")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }


    }
