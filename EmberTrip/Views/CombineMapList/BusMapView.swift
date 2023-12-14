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
    
    var body: some View {
        Map(position: $position) {
            ForEach(combineMapListViewModel.routes ?? []) { route in
                let lat = route.location.lat!
                let lon = route.location.lon!
                Marker(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon)) {
                    VStack {
                        Text(route.location.name)
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
        }
        .onChange(of: combineMapListViewModel.vehicle?.gps) { oldValue, newValue in
            withAnimation {
                busLocation = CLLocationCoordinate2D(latitude: newValue?.latitude ?? 0, longitude: newValue?.longitude ?? 0)
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
}

#Preview {
    BusMapView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
