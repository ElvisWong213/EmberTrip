//
//  TripInfoRequest.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import Foundation

struct TripInfoRequest: Codable {
    let id: Int
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
    
    enum CodingKeys: String, CodingKey {
        case id, all, availability, description, passes, price, route, shift, vehicle
        case includeCancelledStops = "include_cancelled_stops"
        case updateSkipped = "update_skipped"
    }
}
