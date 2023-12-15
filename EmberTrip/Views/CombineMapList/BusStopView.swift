//
//  BusStopView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI
import MapKit

struct BusStopView: View {
    @EnvironmentObject var combineMapListViewModel: CombineMapListViewModel
    @State private var showActualTime = false
    @State private var routes: [Route] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(routes) { route in
                    Button {
                        guard let lat = route.location.lat, let lon = route.location.lon else {
                            return
                        }
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        withAnimation {
                            combineMapListViewModel.cameraPosition = .item(MKMapItem(placemark: .init(coordinate: coordinate)))
                        }
                    } label: {
                        BusStopInformationRow(scheduled: route.departure.scheduled, estimated: route.departure.estimated, location: route.location.name, showActualTime: showActualTime)
                    }
                    .buttonStyle(.plain)
                }
            }
            .overlay {
                if routes.isEmpty {
                    Text("Oops, looks like there's no data...")
                }
            }
            .navigationTitle("Route Details")
            .toolbar {
                ToolbarItem {
                    Button {
                        showActualTime.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right")
                            .bold(showActualTime)
                    }
                }
            }
        }
        .onChange(of: combineMapListViewModel.routes) { oldValue, newValue in
            if let newValue = newValue {
                routes = newValue
            }
        }
        .onAppear() {
            if let rotues = combineMapListViewModel.routes {
                routes = rotues
            }
        }
    }
}

#Preview {
    BusStopView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
