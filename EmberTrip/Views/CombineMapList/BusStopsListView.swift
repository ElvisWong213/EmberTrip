//
//  BusStopsListView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI
import MapKit

struct BusStopsListView: View {
    @EnvironmentObject var combineMapListVM: CombineMapListViewModel
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
                .onAppear() {
                    setupInitialSelectedStop(proxy)
                }
                .onChange(of: combineMapListVM.selectedStopId) {
                    scrollToSelectedStop(proxy)
                }
            }
        }
    }
    
    private func selectStop(lat: Double?, lon: Double?, id: Int) {
        guard let lat, let lon else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        withAnimation {
            combineMapListVM.cameraPosition = .item(MKMapItem(placemark: .init(coordinate: coordinate)))
            combineMapListVM.selectedStopId = id
        }
    }
    
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
    
    private func setupInitialSelectedStop(_ proxy: ScrollViewProxy) {
        guard let nextStopId = getNextStopId() else {
            return
        }
        withAnimation {
            combineMapListVM.selectedStopId = nextStopId
            proxy.scrollTo(nextStopId)
        }
    }

    private func scrollToSelectedStop(_ proxy: ScrollViewProxy) {
        withAnimation {
            proxy.scrollTo(combineMapListVM.selectedStopId)
        }
    }
}

#Preview {
    BusStopsListView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
