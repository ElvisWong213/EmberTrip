//
//  NetworkService.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

class NetworkService {
    static func makeRequest<T: Codable>(request: RestEnum) async throws -> T {
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
        
        // Decode data
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
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

