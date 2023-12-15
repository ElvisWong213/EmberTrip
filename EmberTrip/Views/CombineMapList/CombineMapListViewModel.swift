//
//  CombineMapListViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation
import MapKit
import SwiftUI

class CombineMapListViewModel: ObservableObject {
    let tripId: String
    
    @Published var routes: [Route]?
    @Published var vehicle: Vehicle?
    @Published var description: TripInfoResponsesDescription?
    @Published var cameraPosition: MapCameraPosition
    
    let mock: Bool

    init(tripId: String) {
        self.tripId = tripId
        self.routes = nil
        self.vehicle = nil
        self.description = nil
        self.mock = false
        self.cameraPosition = .automatic
    }
    
    init(mock: Bool) {
        self.tripId = ""
        let tripInfo = TripInfoResponses.loadMockData()
        self.routes = tripInfo?.route
        self.vehicle = tripInfo?.vehicle
        self.description = tripInfo?.description
        self.mock = mock
        self.cameraPosition = .automatic
    }
    
    func getData() {
        if mock {
            return
        }
        Task {
            let requset = TripInfoRequest(id: tripId)
            do {
                let response = try await NetworkService.makeRequest(request: .getTripInfo(tripInfoRequest: requset)) as TripInfoResponses
                DispatchQueue.main.async {
                    if response.route != nil {
                        self.routes = response.route
                        self.vehicle = response.vehicle
                        self.description = response.description
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
