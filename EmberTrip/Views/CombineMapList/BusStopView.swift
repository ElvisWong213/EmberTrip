//
//  BusStopView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI
import MapKit

struct BusStopView: View {
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
                        BusStopInformationRow(scheduled: stop.arrival.scheduled, estimated: stop.arrival.estimated, location: stop.location.name, showActualTime: showActualTime)
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
                    withAnimation {
                        combineMapListVM.selectedStopId = getNextStopId()
                        proxy.scrollTo(combineMapListVM.selectedStopId)
                    }
                }
                .onChange(of: combineMapListVM.selectedStopId) { oldValue, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue)
                    }
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
        let times = stops.compactMap{ $0.arrival.estimated?.toDate() }.map { Float(Date.now.distance(to: $0)) }
        for (index, time) in times.enumerated() {
            if time > 0 {
                return stops[index + 1].id
            }
        }
        return nil
    }
}

#Preview {
    BusStopView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
