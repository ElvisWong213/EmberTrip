//
//  QuotesRequest.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation

struct QuotesRequest: Codable {
    let destination: Int
    let origin: Int
    let arrivalDateFrom: Date? 
    let arrivalDateTo: Date? 
    let departureDateFrom: Date? 
    let departureDateTo: Date? 
    let replacingPassCode: String? 
    
    init(destination: Int, origin: Int, arrivalDateFrom: Date? = nil, arrivalDateTo: Date? = nil, departureDateFrom: Date? = nil, departureDateTo: Date? = nil, replacingPassCode: String? = nil) {
        self.destination = destination
        self.origin = origin
        self.arrivalDateFrom = arrivalDateFrom
        self.arrivalDateTo = arrivalDateTo
        self.departureDateFrom = departureDateFrom
        self.departureDateTo = departureDateTo
        self.replacingPassCode = replacingPassCode
    }
    
    
    enum CodingKeys: String, CodingKey {
        case destination
        case origin
        case arrivalDateFrom = "arrival_date_from"
        case arrivalDateTo = "arrival_date_to"
        case departureDateFrom = "departure_date_from"
        case departureDateTo = "departure_date_to"
        case replacingPassCode = "replacing_pass_code"
    }
}

extension QuotesRequest: MyURLRequestProtocol {
    /// Returns an array of URLQueryItem objects based on the properties of the current object.
    /// - Returns: An array of URLQueryItem objects representing the properties of the current object.
    func getURLQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase

        do {
            let data = try encoder.encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            for (key, value) in dictionary ?? [:] {
                if let stringValue = value as? String {
                    queryItems.append(URLQueryItem(name: key, value: stringValue))
                } else if let intValue = value as? Int {
                    queryItems.append(URLQueryItem(name: key, value: "\(intValue)"))
                } else if let dateValue = value as? Double {
                    let date = Date(timeIntervalSinceReferenceDate: dateValue)
                    let dateString = ISO8601DateFormatter().string(from: date)
                    queryItems.append(URLQueryItem(name: key, value: dateString))
                }
            }
        } catch {
            print("Error encoding QuotesRequest: \(error)")
        }

        return queryItems
    }
}

