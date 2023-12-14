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
    let arrivalDateFrom: Date? = nil
    let arrivalDateTo: Date? = nil
    let departureDateFrom: Date? = nil
    let departureDateTo: Date? = nil
    let replacingPassCode: String? = nil
    
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
    func getURLQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let label = child.label?.codingKey.stringValue else {
                continue
            }
            if let value = child.value as? String {
                queryItems.append(URLQueryItem(name: label, value: value))
            } else if let value = child.value as? Date {
                queryItems.append(URLQueryItem(name: label, value: value.ISO8601Format()))
            }
        }
        return queryItems
    }
}

