//
//  NetworkService.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

/// A service for making asynchronous network requests and decoding the response.
class NetworkService {

    /// Makes an async network request and returns the decoded response data.
    /// - Parameters:
    ///     - request: An enum value representing the REST API endpoint and its configuration.
    /// - Throws: `NetworkError` if an error occurs during the transmission or processing of the request.
    /// - Returns: The decoded response data of type `T`.
    static func makeRequest<T: Codable>(request: RestEnum) async throws -> T {
        let task = Task {
            // If the URL is nil, throw an invalid URL error
            guard var urlComps = URLComponents(string: request.url) else {
                throw NetworkError.InvalidURL
            }
            
            // Add query items
            urlComps.queryItems = request.queryItems
            
            // Setup request with URL
            var urlRequest = URLRequest(url: urlComps.url!)
            
            // Define request method
            urlRequest.httpMethod = request.method
            
            // Send request
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // If the response is invalid, throw an invalid response error
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                print(response)
                throw NetworkError.InvalidResponse
            }
            return data
        }

        // Timeout after 5 seconds
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: 5000000000)
            task.cancel()
        }

        // Decode data
        let decoded = try await JSONDecoder().decode(T.self, from: task.value)
        timeoutTask.cancel()
        return decoded
    }
}


enum NetworkError: LocalizedError {
    case InvalidResponse, InvalidURL, InvalidData
}

enum RestEnum {
    // Trip Info
    case getTripInfo(tripInfoRequest: TripInfoRequest)
    
    // Quotes
    case getQuotes(quotesRequest: QuotesRequest)
    
    // MARK: Invalid request for unit test
    case invalidRequest
    case emptyRequest
    
    // MARK: Valid request for unit test
    case locations
}

extension RestEnum {
    
    // Requset method
    var method: String {
        switch self {
        case .getTripInfo, .getQuotes, .locations, .invalidRequest, .emptyRequest:
            return "GET"
        }
    }
    
    // API base url
    private var baseURL: String {
        get {
            return "https://api.ember.to/v1/"
        }
    }
    
    // API url
    var url: String {
        switch self {
        case .getTripInfo(let tripInfoRequest):
            return baseURL + "trips/\(tripInfoRequest.id)/"
        case .getQuotes:
            return baseURL + "quotes/"
        case .invalidRequest:
            return "https://www.example.com:8800/"
        case .emptyRequest:
            return ""
        case .locations:
            return baseURL + "locations/"
        }
    }
    
    // Request query items
    var queryItems: [URLQueryItem] {
        switch self {
        case .getTripInfo(let tripInfoRequest):
            return tripInfoRequest.getURLQueryItems()
        case .getQuotes(let quotesRequest):
            return quotesRequest.getURLQueryItems()
        case .invalidRequest:
            return []
        case .emptyRequest:
            return []
        case .locations:
            return []
        }
    }
}
