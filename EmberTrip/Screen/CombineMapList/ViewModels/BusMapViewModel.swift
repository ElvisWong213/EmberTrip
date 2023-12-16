//
//  BusMapViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation
import MapKit
import SwiftUI

class BusMapViewModel: ObservableObject {
    @Published var busLocation: CLLocationCoordinate2D?
    
    @Published var cameraLockToBus: Bool = false
    
    @Published var stops: [BusStop] = []
    @Published var routes: [MKRoute] = []
    
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
    
    func calculateAllRoutes() {
        guard stops.count > 1 else { return }
        self.routes = []
        for stopIndex in 0..<stops.count - 1 {
            calculateRoute(start: stops[stopIndex].coordinate, end: stops[stopIndex + 1].coordinate)
        }
    }
    
    func updateBusLocation(newLocation: Gps?) {
        guard let latitude = newLocation?.latitude, let longitude = newLocation?.longitude else {
            return
        }
        withAnimation {
            busLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func newCameraPosition() -> MapCameraPosition? {
        guard let busLocation else {
            return nil
        }
        return .camera(MapCamera(centerCoordinate: busLocation, distance: 10000))
    }
}
