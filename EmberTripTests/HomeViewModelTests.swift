//
//  HomeViewModelTests.swift
//  EmberTripTests
//
//  Created by Elvis on 17/12/2023.
//

import XCTest
@testable import EmberTrip

@MainActor
final class HomeViewModelTests: XCTestCase {
    var homeViewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        homeViewModel = HomeViewModel()
    }
    
    override func tearDown() {
        homeViewModel = nil
        super.tearDown()
    }
    
    func testGetData() {
        let expectation = XCTestExpectation(description: "Data fetched successfully")

        Task {
            await homeViewModel.getData()
            XCTAssertNotNil(homeViewModel.quotes)
            XCTAssertFalse(homeViewModel.showErrorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}
