//
//  BusMapView.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI
import MapKit

struct BusMapView: View {
    @EnvironmentObject var combineMapListVM: CombineMapListViewModel
    
    @State private var busLocation: CLLocationCoordinate2D?
    
    @State private var cameraLockToBus: Bool = false
    
    @State private var stops: [BusStop] = []
    @State private var routes: [MKRoute] = []
    
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Map(position: $combineMapListVM.cameraPosition, selection: $combineMapListVM.selectedStopId) {
                    ForEach(stops) { stop in
                        Marker(coordinate: stop.coordinate) {
                            Text(stop.name)
                        }
                        .tag(stop.id)
                    }
                    if busLocation != nil {
                        Annotation("BUS", coordinate: busLocation!, anchor: .bottom) {
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
                    if !routes.isEmpty {
                        ForEach(routes, id: \.self) { route in
                            MapPolyline(route)
                                .stroke(.blue, lineWidth: 10)
                        }
                    }
                }
                
                // Title bar
                VStack(spacing: 0) {
                    ZStack {
                        HStack {
                            Button {
                                dissmiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title3)
                            }
                            Spacer()
                        }
                        // Title
                        Text("\(combineMapListVM.description?.routeNumber ?? "") \(Image(systemName: "chevron.forward.circle.fill")) \(stops.last?.name ?? "")")
                    }
                    .padding()
                    .background()
                    HStack {
                        Spacer()
                        Text("Last update: \(lastUpdateDate())")
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .background(combineMapListVM.internetConnection ? .green : .red)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: combineMapListVM.vehicle?.gps) { oldValue, newValue in
            withAnimation {
                guard let newValue else {
                    return
                }
                busLocation = CLLocationCoordinate2D(latitude: newValue.latitude ?? 0, longitude: newValue.longitude ?? 0)
                if busLocation != nil && cameraLockToBus {
                    combineMapListVM.cameraPosition = .camera(MapCamera(centerCoordinate: busLocation!, distance: 800))
                }
            }
        }
        .onAppear() {
            withAnimation {
                let vehicleLocation = combineMapListVM.vehicle?.gps
                busLocation = CLLocationCoordinate2D(latitude: vehicleLocation?.latitude ?? 0, longitude: vehicleLocation?.longitude ?? 0)
            }
            loadBusStops()
            calculateAllRoutes()
        }
//        .safeAreaInset(edge: .top) {
//            HStack {
//                Spacer()
//                Button {
//                    withAnimation {
//                        if busLocation != nil {
//                            combineMapListViewModel.cameraPosition = .camera(MapCamera(centerCoordinate: busLocation!, distance: 800))
//                        }
//                    }
//                    cameraLockToBus.toggle()
//                } label: {
//                    Image(systemName: "bus")
//                        .font(.title)
//                        .background(.white)
//                }
//                .padding()
//            }
//        }
    }
    
    private func lastUpdateDate() -> String {
        guard let updateDate = (combineMapListVM.vehicle?.gps?.lastUpdated ?? "").toDate() else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: updateDate)
    }
    
    private func loadBusStops() {
        guard let routes = combineMapListVM.routes else { return }
        for route in routes {
            guard let lat = route.location.lat, let lon = route.location.lon else {
                continue
            }
            stops.append(BusStop(id: route.id, name: route.location.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
        }
    }
    
    private func calculateRoute(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let route = response?.routes.first {
                self.routes.append(route)
            }
        }
    }
    
    private func calculateAllRoutes() {
        guard stops.count > 1 else { return }
        self.routes = []
        for stopIndex in 0..<stops.count - 1 {
            calculateRoute(start: stops[stopIndex].coordinate, end: stops[stopIndex + 1].coordinate)
        }
    }
}

#Preview {
    BusMapView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
