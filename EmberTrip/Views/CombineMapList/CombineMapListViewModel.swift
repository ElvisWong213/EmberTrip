//
//  CombineMapListViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation

class CombineMapListViewModel: ObservableObject {
    let tripId: String
    @Published var tripInfo: TripInfoResponses?
    
    var mock: Bool = false
    
    init(tripId: String, tripInfo: TripInfoResponses? = nil) {
        self.tripId = tripId
        self.tripInfo = tripInfo
    }
    
    init(mock: Bool) {
        self.mock = true
        self.tripId = ""
        self.tripInfo = TripInfoResponses.loadMockData()
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
                        self.tripInfo = response
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
