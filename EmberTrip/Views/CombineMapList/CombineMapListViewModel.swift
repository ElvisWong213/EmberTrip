//
//  CombineMapListViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation

class CombineMapListViewModel: ObservableObject {
    let tripId: String
    
    @Published var routes: [Route]?
    @Published var vehicle: Vehicle?
    
    let mock: Bool

    init(tripId: String, routes: [Route]? = nil, vehicle: Vehicle? = nil) {
        self.tripId = tripId
        self.routes = routes
        self.vehicle = vehicle
        self.mock = false
    }
    
    init(mock: Bool) {
        self.tripId = ""
        let tripInfo = TripInfoResponses.loadMockData()
        self.routes = tripInfo?.route
        self.vehicle = tripInfo?.vehicle
        self.mock = mock
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
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
