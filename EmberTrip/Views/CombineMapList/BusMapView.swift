//
//  BusMapView.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI
import MapKit

struct BusMapView: View {
    @EnvironmentObject var combineMapListViewModel: CombineMapListViewModel
    
    @State private var position: MapCameraPosition = .automatic
    @State private var busLocation: CLLocationCoordinate2D?
    
    @State private var cameraLockToBus: Bool = false
    
    @State private var stops: [BusStop] = []
    @State private var routes: [MKRoute] = []
    
    var body: some View {
        Map(position: $position) {
            ForEach(stops) { stop in
                Marker(coordinate: stop.coordinate) {
                    VStack {
                        Text(stop.name)
                    }
                }
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
            if !routes.isEmpty {
                ForEach(routes, id: \.self) { route in
                    MapPolyline(route)
                        .stroke(.blue, lineWidth: 10)
                }
            }
            
        }
        .onChange(of: combineMapListViewModel.vehicle?.gps) { oldValue, newValue in
            withAnimation {
                guard let newValue else {
                    return
                }
                busLocation = CLLocationCoordinate2D(latitude: newValue.latitude ?? 0, longitude: newValue.longitude ?? 0)
                if busLocation != nil && cameraLockToBus {
                    position = .camera(MapCamera(centerCoordinate: busLocation!, distance: 800))
                }
            }
        }
        .onAppear() {
            withAnimation {
                let vehicleLocation = combineMapListViewModel.vehicle?.gps
                busLocation = CLLocationCoordinate2D(latitude: vehicleLocation?.latitude ?? 0, longitude: vehicleLocation?.longitude ?? 0)
            }
            loadBusStops()
            calculateAllRoutes()
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        if busLocation != nil {
                            position = .camera(MapCamera(centerCoordinate: busLocation!, distance: 800))
                        }
                    }
                    cameraLockToBus.toggle()
                } label: {
                    Image(systemName: "bus")
                        .font(.title)
                        .background(.white)
                }
                .padding()
            }
        }
    }
    
    private func loadBusStops() {
        guard let routes = combineMapListViewModel.routes else { return }
        for route in routes {
            guard let lat = route.location.lat, let lon = route.location.lon else {
                continue
            }
            stops.append(BusStop(name: route.location.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)))
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
