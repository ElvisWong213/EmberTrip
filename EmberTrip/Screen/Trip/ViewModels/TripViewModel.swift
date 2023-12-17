//
//  TripViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import Foundation
import MapKit
import SwiftUI

/// A view model that provides data for the TripView.
/// You should use this view model to retrieve and manage data related to a specific trip and display it in the UI.
/// - Note: This class is designed to work with SwiftUI's ObservableObject protocol and should be accessed through TripView.
@MainActor
class TripViewModel: ObservableObject {
    /// The identifier of the trip to fetch data for.
    var tripId: String

    /// An array of routes for the trip.
    @Published var routes: [Route]? = nil

    /// The vehicle associated with the trip.
    @Published var vehicle: Vehicle? = nil

    /// Descriptive information regarding the trip.
    @Published var description: TripInfoResponsesDescription? = nil

    /// The camera position for the map view.
    @Published var cameraPosition: MapCameraPosition = .automatic

    /// The identifier of the selected stop.
    @Published var selectedStopId: Int? = nil

    /// A boolean that indicates the availability of internet connection.
    @Published var internetConnection = true

    /// A boolean that indicates whether to show a banner with specific message.
    @Published var showBanner = false

    /// The type of message to be displayed in the banner.
    @Published var bannerMessageType: BannerMessage = .NetworkError

    /// A boolean indicating whether to use mock data.
    let mock: Bool

    /// Initializes the view model with a specific trip identifier.
    /// - Parameter tripId: The identifier of the trip to fetch data for.
    init(tripId: String) {
        self.tripId = tripId
        self.mock = false
        // Load cached file when the user recover previous session
        if tripId == "" {
            self.loadCache()
        }
    }
    #if DEBUG
    /// Initializes the view model with mock data.
    /// - Parameter mock: A boolean indicating whether to use mock data.
    init(mock: Bool) {
        self.tripId = ""
        self.routes = TripInfoResponses.loadMockData()?.route
        self.vehicle = TripInfoResponses.loadMockData()?.vehicle
        self.description = TripInfoResponses.loadMockData()?.description
        self.mock = mock
    }
    #endif

    /// Fetches the trip data from the backend asynchronously.
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
            // Display the banner and ensure that it only appears once.
            if internetConnection {
                bannerMessageType = .NetworkError
                showBanner = true
            }
            internetConnection = false
        }
    }

    /// Loads data from the cache.
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
