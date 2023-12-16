//
//  NetworkService.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

class NetworkService {
    static let cacheFileName = "cache"
    static var internetConnectionLost = false
    
    static func makeRequest<T: Codable>(request: RestEnum) async throws -> T {
        let task = Task {
            // If url is nil throw error
            guard var urlComps = URLComponents(string: request.baseURL + request.path) else {
                throw NetworkError.InvalidURL
            }
            
            urlComps.queryItems = request.queryItems
        
            // Setup requset with url
            var urlRequest = URLRequest(url: urlComps.url!)
            
            // Define request method
            urlRequest.httpMethod = request.method
        
            // Send requset
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            // If respone is invalid throw error
            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                print(response)
                throw NetworkError.InvalidResponse
            }
            return data
        }
        
        // Timeout after 5 second
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: 5000000000)
            task.cancel()
            print("Time Out")
            internetConnectionLost = true
        }
        
        // Decode data
        let decoded = try await JSONDecoder().decode(T.self, from: task.value)
        timeoutTask.cancel()
        internetConnectionLost = false
        return decoded
    }
    
    static func saveDataToFile<T: Codable>(data: T) throws {
        let filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(self.cacheFileName, conformingTo: .json)
        let encode = try JSONEncoder().encode(data)
        try encode.write(to: filePath)
    }
    
    static func loadDataFromFile<T: Codable>(fileURL: URL, type: T.Type) -> T? {
        do {
            // Read the contents of the JSON file
            let data = try Data(contentsOf: fileURL)
            
            // Create a JSONDecoder instance
            let decoder = JSONDecoder()
            
            // Decode the JSON data into the MyData struct
            let decodedData = try decoder.decode(type, from: data)
            
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        return nil
    }
}


enum NetworkError: LocalizedError {
    case InvalidResponse, InvalidURL, InvalidToken, InvalidData
}

enum RestEnum {
    // Trip Info
    case getTripInfo(tripInfoRequest: TripInfoRequest)
    
    // Quotes
    case getQuotes(quotesRequest: QuotesRequest)
}

extension RestEnum {
    
    // Requset method
    var method: String {
        switch self {
        case .getTripInfo, .getQuotes:
            return "GET"
        }
    }
    
    // API base url
    var baseURL: String {
        get {
            return "https://api.ember.to/v1/"
        }
    }
    
    // API path
    var path: String {
        switch self {
        case .getTripInfo(let tripInfoRequest):
            return "trips/\(tripInfoRequest.id)/"
        case .getQuotes:
            return "quotes/"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getTripInfo(let tripInfoRequest):
            return tripInfoRequest.getURLQueryItems()
        case .getQuotes(let quotesRequest):
            return quotesRequest.getURLQueryItems()
        }
    }
}

