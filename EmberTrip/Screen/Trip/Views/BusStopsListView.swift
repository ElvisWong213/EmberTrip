//
//  BusStopsListView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI
import MapKit

struct BusStopsListView: View {
    @EnvironmentObject var combineMapListVM: TripViewModel
    @State private var showActualTime = false
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List(combineMapListVM.routes ?? [], selection: $combineMapListVM.selectedStopId) { stop in
                    HStack {
                        Image(systemName: "bus")
                            .symbolEffect(.pulse)
                            .opacity(stop.id == getNextStopId() ? 1 : 0)
                        BusStopInformationRow(scheduled: stop.arrival.scheduled, 
                                              estimated: stop.arrival.estimated,
                                              location: stop.location.name,
                                              showActualTime: showActualTime)
                    }
                    .id(stop.id)
                    .onTapGesture {
                        selectStop(lat: stop.location.lat, lon: stop.location.lon, id: stop.id)
                    }
                }
                .overlay {
                    if combineMapListVM.routes == nil {
                        Text("Oops, looks like there's no data...")
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
                .onAppear() {
                    setupInitialSelectedStop(proxy)
                }
                .onChange(of: combineMapListVM.selectedStopId) {
                    scrollToSelectedStop(proxy)
                }
            }
            .navigationTitle("Route Details")
            .toolbarTitleDisplayMode(.inline)
        }
    }
    
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
            combineMapListVM.cameraPosition = .item(MKMapItem(placemark: MKPlacemark(coordinate: coordinate)))
            combineMapListVM.selectedStopId = id
        }
    }

    /// Retrieves the ID of the next stop.
    /// - Returns: The unique identifier of the next stop if available; otherwise, returns nil.
    private func getNextStopId() -> Int? {
        guard let stops = combineMapListVM.routes else {
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

    /// Sets up the initially selected stop and scrolls to it.
    /// - Parameters:
    ///    - proxy: The scrollView proxy used for scrolling.
    private func setupInitialSelectedStop(_ proxy: ScrollViewProxy) {
        guard let nextStopId = getNextStopId() else {
            return
        }
        withAnimation {
            // Updates the selected stop ID to the next stop and scrolls to it using the provided scrollView proxy.
            combineMapListVM.selectedStopId = nextStopId
            proxy.scrollTo(nextStopId)
        }
    }

    /// Scrolls to the selected stop using the provided scrollView proxy.
    /// - Parameters:
    ///    - proxy: The scrollView proxy used for scrolling.
    private func scrollToSelectedStop(_ proxy: ScrollViewProxy) {
        withAnimation {
            // Scrolls to the selected stop using the provided scrollView proxy.
            proxy.scrollTo(combineMapListVM.selectedStopId)
        }
    }
}

#Preview {
    BusStopsListView()
        .environmentObject(TripViewModel(mock: true))
}
