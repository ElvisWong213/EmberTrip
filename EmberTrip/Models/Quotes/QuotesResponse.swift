//
//  QuotesResponse.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation

// MARK: - QuotesResponse
struct QuotesResponse: Codable {
    let quotes: [Quotes]
}

struct Quotes: Identifiable, Codable {
    var id = UUID()
    let availability: Availability?
    let legs: [Leg]?
    let prices: Prices?
    
    enum CodingKeys: String, CodingKey {
        case availability
        case legs
        case prices
    }
    
}

extension QuotesResponse {
    static func loadMockData() -> QuotesResponse? {
        // Get the file URL of the JSON file
        guard let fileURL = Bundle.main.url(forResource: "Quotes", withExtension: "json") else {
            print("JSON file not found")
            return nil
        }
        
        do {
            // Read the contents of the JSON file
            let data = try Data(contentsOf: fileURL)
            
            // Create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            // Decode the JSON data into the MyData struct
            let decodedData = try decoder.decode(QuotesResponse.self, from: data)
            
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
}
