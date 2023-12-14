//
//  BusStop.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation
import MapKit

struct BusStop: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
