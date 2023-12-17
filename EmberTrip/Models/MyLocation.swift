//
//  MyLocation.swift
//  EmberTrip
//
//  Created by Elvis on 17/12/2023.
//

import Foundation

// MARK: - Location
struct MyLocation: Codable, Equatable {
    let id: Int
    let name, type: String
    let description: String?
    let regionName, detailedName: String

    enum CodingKeys: String, CodingKey {
        case id, name, type, description
        case regionName = "region_name"
        case detailedName = "detailed_name"
    }
}

typealias Locations = [MyLocation]
