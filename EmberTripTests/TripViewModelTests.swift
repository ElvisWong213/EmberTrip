//
//  TripViewModelTests.swift
//  EmberTripTests
//
//  Created by Elvis on 17/12/2023.
//

import XCTest
@testable import EmberTrip

@MainActor
final class TripViewModelTests: XCTestCase {
    var viewModel: TripViewModel!
    var homeViewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        viewModel = TripViewModel(tripId: "123")
        homeViewModel = HomeViewModel()
    }

    override func tearDown() {
        viewModel = nil
        homeViewModel = nil
        super.tearDown()
    }

    func testLoadCache() throws {
        let cacheData = Cache(id: "123", tripInfo: TripInfoResponses.loadMockData()!)
        try FileManageService.saveDataToCache(data: cacheData)

        viewModel.loadCache()

        XCTAssertEqual(viewModel.tripId, "123")
        XCTAssertNotNil(viewModel.routes)
        XCTAssertNotNil(viewModel.vehicle)
        XCTAssertNotNil(viewModel.description)
    }
    
    func testGetData() async {
        await homeViewModel.getData()
        guard let tripId = homeViewModel.quotes.first?.legs?.first?.tripUid else {
            XCTFail("Cannot get trip id")
            return
        }
        viewModel.tripId = tripId
        let expectation = expectation(description: "Fetching trip data")

        Task {
            await viewModel.getData()
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 6)
        XCTAssertNotNil(viewModel.routes)
        XCTAssertNotNil(viewModel.vehicle)
        XCTAssertNotNil(viewModel.description)
        XCTAssertTrue(viewModel.internetConnection)
    }
    
    func testGetDataFail() async {
        await viewModel.getData()
        
        XCTAssertNil(viewModel.routes)
        XCTAssertNil(viewModel.vehicle)
        XCTAssertNil(viewModel.description)
        XCTAssertTrue(viewModel.showBanner)
        XCTAssertFalse(viewModel.internetConnection)
        XCTAssertEqual(viewModel.bannerMessageType, .NetworkError)
    }
}
