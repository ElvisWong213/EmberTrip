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
    
    var body: some View {
        if let tripInfo = combineMapListViewModel.tripInfo {
            let vehicleLocation = tripInfo.vehicle?.gps
            Map(initialPosition: .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: vehicleLocation?.latitude ?? 0, longitude: vehicleLocation?.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))) {
                ForEach(tripInfo.route ?? []) { route in
                    let lat = route.location.lat!
                    let lon = route.location.lon!
                    Marker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)) {
                        VStack {
                            Text(route.location.name)
                        }
                    }
                }
                Annotation("BUS", coordinate: CLLocationCoordinate2D(latitude: vehicleLocation?.latitude ?? 0, longitude: vehicleLocation?.longitude ?? 0), anchor: .bottom) {
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
        }
    }
}

#Preview {
    BusMapView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
