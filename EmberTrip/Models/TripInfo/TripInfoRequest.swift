//
//  TripInfoRequest.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

struct TripInfoRequest: Codable {
    let id: String
    let all: Bool? = nil
    let availability: Bool? = nil
    let description: Bool? = nil
    let includeCancelledStops: Bool? = nil
    let passes: Bool? = nil
    let price: Bool? = nil
    let route: Bool? = nil
    let shift: Bool? = nil
    let updateSkipped: Bool? = nil
    let vehicle: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, all, availability, description, passes, price, route, shift, vehicle
        case includeCancelledStops = "include_cancelled_stops"
        case updateSkipped = "update_skipped"
    }
}

extension TripInfoRequest: MyURLRequestProtocol {
    func getURLQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            guard let label = child.label?.codingKey.stringValue, let value = child.value as? String else {
                continue
            }
            if label == "id" {
                continue
            }
            queryItems.append(URLQueryItem(name: label, value: value))
        }
        return queryItems
    }
}
