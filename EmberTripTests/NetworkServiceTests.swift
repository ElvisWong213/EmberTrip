//
//  NetworkServiceTests.swift
//  EmberTripTests
//
//  Created by Elvis on 17/12/2023.
//

import XCTest
@testable import EmberTrip

final class NetworkServiceTests: XCTestCase {
    // Test a successful request
    func testMakeRequestSuccess() async throws {
        struct Response: Codable {
            let message: String
        }
        
        let request = try await NetworkService.makeRequest(request: .locations) as Locations
        let stops = """
        [
          {
            "id": 54,
            "type": "STOP_AREA",
            "name": "Bridge of Earn",
            "region_name": "Bridge of Earn",
            "detailed_name": "Old Edinburgh Road",
            "bookable_from": "2022-02-21T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 49,
            "type": "STOP_AREA",
            "name": "Edinburgh Airport",
            "region_name": "Edinburgh Airport",
            "detailed_name": "Passenger Terminal",
            "bookable_from": "2021-12-18T09:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 14,
            "type": "STOP_AREA",
            "name": "Dundee West",
            "region_name": "Dundee West",
            "detailed_name": "Apollo Way",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 15,
            "type": "STOP_AREA",
            "name": "Inchture",
            "region_name": "Inchture",
            "detailed_name": "Off A90",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 45,
            "type": "STOP_AREA",
            "name": "Ingliston P&R",
            "region_name": "Edinburgh",
            "detailed_name": "Ingliston P&R (for Tram)",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 18,
            "type": "STOP_AREA",
            "name": "Rosyth",
            "region_name": "Rosyth",
            "detailed_name": "St John's & St Columba's Church",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 47,
            "type": "STOP_AREA",
            "name": "Longforgan",
            "region_name": "Longforgan",
            "detailed_name": "Slip Road",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 46,
            "type": "STOP_AREA",
            "name": "St Madoes/Glencarse",
            "region_name": "St Madoes/Glencarse",
            "detailed_name": "Off A90",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 44,
            "type": "STOP_AREA",
            "name": "Edinburgh Zoo",
            "region_name": "Edinburgh",
            "detailed_name": "Edinburgh Zoo",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 16,
            "type": "STOP_AREA",
            "name": "Walnut Grove (for Perth)",
            "region_name": "Walnut Grove",
            "detailed_name": "West Road End (for Perth)",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 43,
            "type": "STOP_AREA",
            "name": "Edinburgh (Haymarket)",
            "region_name": "Edinburgh",
            "detailed_name": "Haymarket",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 21,
            "type": "STOP_AREA",
            "name": "Edinburgh (St. Andrew's House)",
            "region_name": "Edinburgh",
            "detailed_name": "St. Andrews House",
            "bookable_from": "2020-09-01T00:00:00Z",
            "bookable_until": "2021-05-20T22:59:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 20,
            "type": "STOP_AREA",
            "name": "Edinburgh (Princes St)",
            "region_name": "Edinburgh",
            "detailed_name": "Princes Street West",
            "bookable_from": "2020-09-01T00:00:00Z",
            "bookable_until": "2021-05-20T22:59:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 19,
            "type": "STOP_AREA",
            "name": "Edinburgh West",
            "region_name": "Edinburgh West",
            "detailed_name": "Blackhall Library",
            "bookable_from": "2020-09-01T00:00:00Z",
            "bookable_until": "2021-05-20T22:59:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 13,
            "type": "STOP_AREA",
            "name": "Dundee",
            "region_name": "Dundee",
            "detailed_name": "City Centre",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 80,
            "type": "STOP_AREA",
            "name": "Glasgow Bus Station",
            "region_name": "Glasgow",
            "detailed_name": "Buchanan Bus Station",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 78,
            "type": "STOP_AREA",
            "name": "Cumbernauld Town Centre",
            "region_name": "Cumbernauld",
            "detailed_name": "Town Centre",
            "bookable_from": "2022-08-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 79,
            "type": "STOP_AREA",
            "name": "Cumbernauld Greenfaulds",
            "region_name": "Cumbernauld",
            "detailed_name": "Greenfaulds High School",
            "bookable_from": "2022-08-01T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 77,
            "type": "STOP_AREA",
            "name": "Stirling Castleview P&R",
            "region_name": "Stirling",
            "detailed_name": "Castleview P&R",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 76,
            "type": "STOP_AREA",
            "name": "Dunblane",
            "region_name": "Dunblane",
            "detailed_name": "Police Station (near Town Centre)",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 75,
            "type": "STOP_AREA",
            "name": "Greenloaning",
            "region_name": "Greenloaning",
            "detailed_name": "Sherrifmuir Close",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 74,
            "type": "STOP_AREA",
            "name": "Auchterarder (on A9)",
            "region_name": "Auchterarder",
            "detailed_name": "A9 (near Gleneagles Station)",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 73,
            "type": "STOP_AREA",
            "name": "Perth Broxden P&R",
            "region_name": "Perth",
            "detailed_name": "Broxden P&R",
            "bookable_from": "2022-07-14T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 143,
            "type": "STOP_AREA",
            "name": "Dundee MSIP",
            "region_name": "Dundee",
            "code_detail": "Dundee MSIP",
            "detailed_name": "Michelin Scotland Innovation Parc",
            "bookable_from": "2024-01-11T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 145,
            "type": "STOP_AREA",
            "name": "Dundee West Ferry",
            "region_name": "Dundee",
            "detailed_name": "West Ferry",
            "bookable_from": "2024-01-11T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 146,
            "type": "STOP_AREA",
            "name": "Dundee Craigiebank",
            "region_name": "Dundee",
            "detailed_name": "Craigiebank",
            "bookable_from": "2024-01-11T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 144,
            "type": "STOP_AREA",
            "name": "Dundee Baldovie Road Sainsbury's",
            "region_name": "Dundee",
            "detailed_name": "Baldovie Road Sainsbury's",
            "bookable_from": "2024-01-11T00:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 42,
            "type": "STOP_AREA",
            "name": "Edinburgh (City Centre)",
            "region_name": "Edinburgh",
            "detailed_name": "City Centre",
            "bookable_from": "2021-05-21T04:00:00Z",
            "timezone": "Europe/London"
          },
          {
            "id": 17,
            "type": "STOP_AREA",
            "name": "Kinross P&R",
            "region_name": "Kinross",
            "detailed_name": "Kinross P&R",
            "bookable_from": "2020-09-01T00:00:00Z",
            "timezone": "Europe/London"
          }
        ]
        """
        let data = stops.data(using: .utf8)!
        let jsonArray = try JSONDecoder().decode(Locations.self, from: data)
        XCTAssertTrue(request == jsonArray)
    }
    
    // Test a failed response
    func testMakeRequestFailedResponse() async throws {
        struct ErrorResponse: Codable {
            let error: String
        }
        
        do {
            _ = try await NetworkService.makeRequest(request: .getQuotes(quotesRequest: QuotesRequest(destination: 0, origin: 0))) as QuotesResponse
            XCTFail("Expected request to throw an error.")
        } catch {
            XCTAssertTrue(error as! NetworkError == NetworkError.InvalidResponse)
        }
    }
    
    // Test a request with invalid URL
    func testMakeRequestInvalidURL() async throws {
        do {
            _ = try await NetworkService.makeRequest(request: .emptyRequest) as String
            XCTFail("Expected request to throw an error.")
        } catch {
            XCTAssertTrue(error.localizedDescription.contains("unsupported URL"))
        }
    }
    
    // Test a request with a timeout
    func testMakeRequestTimeout() async throws {
        let invalidRequest = RestEnum.invalidRequest
        let expectation = XCTestExpectation(description: "Request timeout")
        
        Task {
            do {
                let _ = try await NetworkService.makeRequest(request: .invalidRequest) as String
            } catch {
                print(error)
                if error.localizedDescription.contains("cancelled") {
                    expectation.fulfill()
                }
            }
        }
        await fulfillment(of: [expectation], timeout: 6)
    }

}
