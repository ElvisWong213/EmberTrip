//
//  CombineMapListViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation
import MapKit
import SwiftUI

@MainActor
class CombineMapListViewModel: ObservableObject {
    var tripId: String
    
    @Published var routes: [Route]? = nil
    @Published var vehicle: Vehicle? = nil
    @Published var description: TripInfoResponsesDescription? = nil
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var selectedStopId: Int? = nil
    @Published var internetConnection = true
    @Published var showBanner = false
    
    let mock: Bool

    init(tripId: String) {
        self.tripId = tripId
        self.mock = false
        if tripId == "" {
            self.loadCache()
        }
    }
    
    init(mock: Bool) {
        self.tripId = ""
        self.routes = TripInfoResponses.loadMockData()?.route
        self.vehicle = TripInfoResponses.loadMockData()?.vehicle
        self.description = TripInfoResponses.loadMockData()?.description
        self.mock = mock
    }
    
    func getData() async {
        if mock {
            return
        }
        let requset = TripInfoRequest(id: tripId)
        do {
            let response = try await NetworkService.makeRequest(request: .getTripInfo(tripInfoRequest: requset)) as TripInfoResponses
            if response.route != nil {
                self.routes = response.route
                self.vehicle = response.vehicle
                self.description = response.description
                try? FileManageService.saveDataToCache(data: Cache(id: self.tripId, tripInfo: response))
                self.internetConnection = true
            }
        } catch {
            print(error)
            if internetConnection {
                showBanner = true
            }
            internetConnection = false
        }
    }
    
    func loadCache() {
        guard let cache = FileManageService.loadDataFormCache() else {
            return
        }
        routes = cache.tripInfo.route
        vehicle = cache.tripInfo.vehicle
        description = cache.tripInfo.description
        tripId = cache.id
    }
}
