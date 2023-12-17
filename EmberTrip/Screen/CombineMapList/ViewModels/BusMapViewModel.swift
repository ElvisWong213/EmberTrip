//
//  BusMapViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation
import MapKit
import SwiftUI

/// A view model for managing bus map-related data and functionality.
class BusMapViewModel: ObservableObject {
    
    /// The current location of the bus.
    @Published var busLocation: CLLocationCoordinate2D?
    
    /// A boolean indicating whether the map camera should be locked to the bus location.
    @Published var cameraLockToBus: Bool = false
    
    /// An array of bus stops displayed on the map.
    @Published var stops: [BusStop] = []
    
    /// An array of calculated routes for the bus map.
    @Published var routes: [MKRoute] = []
    
    /// Calculates a route between two given coordinates and adds it to the `routes` array.
    /// - Parameters:
    ///   - start: The starting coordinate for the route.
    ///   - end: The ending coordinate for the route.
    func calculateRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.routes.append(route)
            }
        }
    }
    
    /// Calculates routes between consecutive bus stops and updates the `routes` array.
    func calculateAllRoutes() {
        guard stops.count > 1 else { return }
        self.routes = []
        for stopIndex in 0..<stops.count - 1 {
            calculateRoute(start: stops[stopIndex].coordinate, end: stops[stopIndex + 1].coordinate)
        }
    }
    
    /// Updates the bus location with the provided GPS coordinates.
    /// - Parameter newLocation: The new GPS location of the bus.
    func updateBusLocation(newLocation: Gps?) {
        guard let latitude = newLocation?.latitude, let longitude = newLocation?.longitude else {
            return
        }
        withAnimation {
            busLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    /// Returns a new camera position centered on the bus location for map display.
    /// - Returns: An optional `MapCameraPosition` representing the new camera position, or `nil` if the bus location is not available.
    func newCameraPosition() -> MapCameraPosition? {
        guard let busLocation else {
            return nil
        }
        return .camera(MapCamera(centerCoordinate: busLocation, distance: 10000))
    }
}
