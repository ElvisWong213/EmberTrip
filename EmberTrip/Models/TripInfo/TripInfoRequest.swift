//
//  TripInfoRequest.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

struct TripInfoRequest: Codable {
    let id: String
    let all: Bool?
    let availability: Bool?
    let description: Bool?
    let includeCancelledStops: Bool?
    let passes: Bool?
    let price: Bool?
    let route: Bool?
    let shift: Bool?
    let updateSkipped: Bool?
    let vehicle: Bool?
    
    init(id: String, all: Bool? = nil, availability: Bool? = nil, description: Bool? = nil, includeCancelledStops: Bool? = nil, passes: Bool? = nil, price: Bool? = nil, route: Bool? = nil, shift: Bool? = nil, updateSkipped: Bool? = nil, vehicle: Bool? = nil) {
        self.id = id
        self.all = all
        self.availability = availability
        self.description = description
        self.includeCancelledStops = includeCancelledStops
        self.passes = passes
        self.price = price
        self.route = route
        self.shift = shift
        self.updateSkipped = updateSkipped
        self.vehicle = vehicle
    }
    
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
