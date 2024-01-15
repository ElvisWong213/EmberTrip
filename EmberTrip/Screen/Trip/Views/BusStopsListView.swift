//
//  BusStopsListView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI
import MapKit

struct BusStopsListView: View {
    @EnvironmentObject var tripVM: TripViewModel
    @State private var showActualTime = false
    @State private var arrivalNotification: ArrivalNotification?
    
    private let notificationService = NotificationService()
    @AppStorage("arrivalNotification") var arrivalNotificationData: Data?
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                if let routes = tripVM.routes {
                    List(routes, selection: $tripVM.selectedStopId) { stop in
                        // List items
                        stopView(stop: stop)
                        .id(stop.id)
                        .onTapGesture {
                            selectStop(lat: stop.location.lat, lon: stop.location.lon, id: stop.id)
                        }
                        // Notification
                        .swipeActions(edge: .leading) {
                            Button {
                                if hadAlert(busStopId: stop.id) {
                                    // Arady created notification
                                    // Remove all notification
                                    removeArrivalNotification()
                                    tripVM.bannerMessageType = .RemoveAlert
                                } else {
                                    // Create Notification
                                    if createArrivalNotification(stop: stop) {
                                        // Success
                                        tripVM.bannerMessageType = .SetAlert
                                    } else {
                                        // Fail
                                        tripVM.bannerMessageType = .FailToSetAlert
                                    }
                                }
                                tripVM.showBanner = true
                            } label: {
                                Image(systemName: hadAlert(busStopId: stop.id) ? "bell.slash" : "bell")
                            }
                            .tint(hadAlert(busStopId: stop.id) ? .red : .yellow)
                        }
                    }
                    .onAppear() {
                        setupInitialSelectedStop(proxy)
                        arrivalNotification = getNotification(data: arrivalNotificationData)
                    }
                    .onChange(of: tripVM.selectedStopId) {
                        scrollToSelectedStop(proxy)
                    }
                } else {
                    Text("Please wait, we are retrieving the data.")
                    ProgressView()
                }
            }
            .toolbar {
                ToolbarItem {
                    // Change the display time format
                    Button {
                        showActualTime.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .bold(showActualTime)
                    }
                }
            }
            .navigationTitle("Route Details")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder func stopView(stop: Route) -> some View {
        HStack {
            Image(systemName: "bus")
                .symbolEffect(.pulse)
                .opacity(stop.id == getNextStopId() ? 1 : 0)
            BusStopInformationRow(scheduled: stop.arrival.scheduled,
                                  estimated: stop.arrival.estimated,
                                  location: stop.location.name,
                                  showActualTime: showActualTime, 
                                  hadAlert: hadAlert(busStopId: stop.id))
        }
    }
}

extension BusStopsListView {
    // MARK: - Bus Stops
    
    /// Selects a stop based on the provided latitude, longitude, and stop ID.
    /// - Parameters:
    ///    - lat: The latitude of the stop.
    ///    - lon: The longitude of the stop.
    ///    - id: The unique identifier of the stop.
    private func selectStop(lat: Double?, lon: Double?, id: Int) {
        guard let lat, let lon else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        withAnimation {
            // Sets the camera position to the selected stop's location on the map and updates the selected stop ID.
            tripVM.cameraPosition = .item(MKMapItem(placemark: MKPlacemark(coordinate: coordinate)))
            tripVM.selectedStopId = id
        }
    }

    /// Retrieves the ID of the next stop.
    /// - Returns: The unique identifier of the next stop if available; otherwise, returns nil.
    private func getNextStopId() -> Int? {
        guard let stops = tripVM.routes else {
            return nil
        }
        let estimatedTimes = stops.compactMap{ $0.arrival.estimated?.toDate() }.map { Float(Date.now.distance(to: $0)) }
        for (index, timeDiff) in estimatedTimes.enumerated() {
            if timeDiff > 0 {
                return stops[index + 1].id
            }
        }
        return nil
    }

    // MARK: - Programmatically scroll list view
    
    /// Sets up the initially selected stop and scrolls to it.
    /// - Parameters:
    ///    - proxy: The scrollView proxy used for scrolling.
    private func setupInitialSelectedStop(_ proxy: ScrollViewProxy) {
        guard let nextStopId = getNextStopId() else {
            return
        }
        withAnimation {
            // Updates the selected stop ID to the next stop and scrolls to it using the provided scrollView proxy.
            tripVM.selectedStopId = nextStopId
            proxy.scrollTo(nextStopId)
        }
    }

    /// Scrolls to the selected stop using the provided scrollView proxy.
    /// - Parameters:
    ///    - proxy: The scrollView proxy used for scrolling.
    private func scrollToSelectedStop(_ proxy: ScrollViewProxy) {
        withAnimation {
            // Scrolls to the selected stop using the provided scrollView proxy.
            proxy.scrollTo(tripVM.selectedStopId)
        }
    }
    
    // MARK: - Notification
    /// Creates an arrival notification for the specified bus stop.
    /// - Parameters:
    ///    - stop: The bus stop for which the arrival notification is created.
    /// - Returns: A boolean value indicating whether the arrival notification was successfully created.
    private func createArrivalNotification(stop: Route) -> Bool {
        // First, remove any existing arrival notifications
        removeArrivalNotification()

        // Create a new arrival notification using the provided bus stop and trip ID
        let newArrivalNotification: ArrivalNotification = ArrivalNotification(id: UUID(), tripId: tripVM.tripId, busStopId: stop.id)

        // Get the current calendar
        let calendar = Calendar.current

        // Convert the scheduled arrival time of the bus stop to a Date object
        guard let arrivalDate = stop.arrival.scheduled.toDate(),
            // Calculate a trigger date 5 minutes before the scheduled arrival time
            let triggerDate = calendar.date(byAdding: .minute, value: -5, to: arrivalDate) else {
                return false
        }

        // Extract date components for creating the notification trigger
        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)

        // Create the notification with the arrival notification details
        guard notificationService.createNotification(title: "Arrival Notification", subtitle: "Arriving soon (\(stop.location.name))", id: newArrivalNotification.id, date: comps) else {
            return false
        }

        // Save the arrival notification data and the arrival notification object
        arrivalNotificationData = toData(notification: newArrivalNotification)
        arrivalNotification = newArrivalNotification
        return true
    }

    /// Removes any existing arrival notifications.
    private func removeArrivalNotification() {
        // Remove all existing notifications
        notificationService.removeAllNotification()

        // Clear the arrival notification and its data
        arrivalNotification = nil
        arrivalNotificationData = nil
    }

    /// Converts the arrival notification object to Data for storage.
    /// - Parameters:
    ///    - notification: The arrival notification to be converted to Data.
    /// - Returns: A Data object representing the arrival notification, or nil if conversion fails.
    private func toData(notification: ArrivalNotification) -> Data? {
        guard let data = try? JSONEncoder().encode(notification) else {
            return nil
        }
        return data
    }

    /// Retrieves the arrival notification object from the provided Data.
    /// - Parameters:
    ///    - data: The Data object representing the arrival notification.
    /// - Returns: An ArrivalNotification object decoded from the provided Data, or nil if decoding fails.
    private func getNotification(data: Data?) -> ArrivalNotification? {
        guard let data = data, let arrivalNotification = try? JSONDecoder().decode(ArrivalNotification.self, from: data) else {
            return nil
        }
        return arrivalNotification
    }

    /// Checks if an arrival alert exists for a specific bus stop.
    /// - Parameters:
    ///    - busStopId: The ID of the bus stop to be checked.
    /// - Returns: A boolean value indicating whether an arrival alert exists for the specified bus stop.
    private func hadAlert(busStopId: Int) -> Bool {
        if arrivalNotification?.tripId == tripVM.tripId && arrivalNotification?.busStopId == busStopId {
            return true
        }
        return false
    }
}

#Preview {
    BusStopsListView()
        .environmentObject(TripViewModel(mock: true))
}
