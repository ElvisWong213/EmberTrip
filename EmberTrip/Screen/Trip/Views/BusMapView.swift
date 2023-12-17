//
//  BusMapView.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI
import MapKit

struct BusMapView: View {
    @EnvironmentObject var combineMapListVM: TripViewModel
    @StateObject var viewModel: BusMapViewModel = BusMapViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Map(position: $combineMapListVM.cameraPosition, selection: $combineMapListVM.selectedStopId) {
                    // Bus stop markers
                    ForEach(viewModel.stops) { stop in
                        Marker(coordinate: stop.coordinate) {
                            Text(stop.name)
                        }
                        .tag(stop.id)
                    }
                    if viewModel.busLocation != nil {
                        // Bus Location
                        Annotation("BUS", coordinate: viewModel.busLocation!, anchor: .bottom) {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.indigo.opacity(0.5))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "bus")
                                    .symbolEffect(.pulse.byLayer)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(Color.indigo)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    // Show routes
                    if !viewModel.routes.isEmpty {
                        ForEach(viewModel.routes, id: \.self) { route in
                            MapPolyline(route)
                                .stroke(.blue, lineWidth: 10)
                        }
                    }
                }
                BusMapTitleBar()
                    .environmentObject(viewModel)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: combineMapListVM.cameraPosition) { oldValue, newValue in
            if newValue.camera == nil {
                viewModel.cameraLockToBus = false
            }
        }
        .onChange(of: combineMapListVM.vehicle?.gps) {
            viewModel.updateBusLocation(newLocation: combineMapListVM.vehicle?.gps)
            updateCameraPosition()
        }
        .onAppear() {
            viewModel.updateBusLocation(newLocation: combineMapListVM.vehicle?.gps)
            loadBusStops()
            viewModel.calculateAllRoutes()
        }
    }
    
    /// Updates the camera position of the map view.
    /// If the new camera position is available and the camera is locked to the bus, this method updates the camera position of the map view with a smooth animation.
    /// - Note: This method relies on the `viewModel` instance to obtain the new camera position and determine if the camera should be locked to the bus.
    /// - Important: Make sure to call this method within an animation block using `withAnimation`.
    private func updateCameraPosition() {
        withAnimation {
            guard let newCameraPosition = viewModel.newCameraPosition(), viewModel.cameraLockToBus else {
                return
            }
            combineMapListVM.cameraPosition = newCameraPosition
        }
    }

    /// Loads bus stops from the `combineMapListVM.routes` and appends them to the `viewModel.stops` array.
    /// - Note: This method iterates through the routes stored in `combineMapListVM.routes` and creates `BusStop` instances for each route with valid latitude and longitude.
    /// - Important: Make sure that `combineMapListVM.routes` is not `nil` before calling this method.
    private func loadBusStops() {
        guard let routes = combineMapListVM.routes else { return }
        for route in routes {
            guard let lat = route.location.lat, let lon = route.location.lon else {
                continue
            }
            viewModel.stops.append(BusStop(id: route.id, name: route.location.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
        }
    }
}

#Preview {
    BusMapView()
        .environmentObject(TripViewModel(mock: true))
}
