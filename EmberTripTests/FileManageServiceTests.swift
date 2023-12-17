//
//  FileManageServiceTests.swift
//  EmberTripTests
//
//  Created by Elvis on 17/12/2023.
//

import XCTest
@testable import EmberTrip

final class FileManageServiceTests: XCTestCase {
    func testLoadDataFromFile() {
        guard let fileURL = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("JSON file not found")
            return
        }

        let loadedData = FileManageService.loadDataFromFile(fileURL: fileURL, type: QuotesResponse.self)
        
        XCTAssertNotNil(loadedData, "Loaded data should not be nil")
    }
    
    func testSaveDataToCache() {
        let testCacheData: Cache = Cache(id: "", tripInfo: TripInfoResponses.loadMockData()!)
        
        do {
            try FileManageService.saveDataToCache(data: testCacheData)
            
            XCTAssert(true, "Data should be saved to cache without throwing an error")
        } catch {
            XCTFail("Saving data to cache should not throw an error: \(error)")
        }
    }
    
    func testLoadDataFromCache() {
        let loadedCacheData = FileManageService.loadDataFormCache()
        
        XCTAssertNotNil(loadedCacheData, "Loaded cache data should not be nil")
    }
    
    func testRemoveCache() {
        FileManageService.removeCache()
        
        let filePath = try? FileManageService.cacheFilePath()
        XCTAssertFalse(FileManager.default.fileExists(atPath: filePath?.path ?? ""))
    }
}
