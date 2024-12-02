

import XCTest
import Combine
@testable import TrendingMoviesModule



final class TrendingMoviesViewModelTests: XCTestCase {
    
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
    
    func testFetchGenres() {
        let expectation = XCTestExpectation(description: "Fetch genres")
        
        viewModel.$genres
            .dropFirst()
            .sink { genres in
                XCTAssertEqual(genres, mockGenres)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchGenres()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
