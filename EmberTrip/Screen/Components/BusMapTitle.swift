//
//  BusMapTitleBar.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import SwiftUI
import MapKit

struct BusMapTitleBar: View {
    @EnvironmentObject var combineMapListVM: CombineMapListViewModel
    @EnvironmentObject var busMapVM: BusMapViewModel
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        // Title bar
        VStack(spacing: 0) {
            ZStack {
                // Buttons
                HStack {
                    Button {
                        dissmiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                    }
                    Spacer()
                    Button {
                        updateCameraPosition()
                        busMapVM.cameraLockToBus.toggle()
                    } label: {
                        Image(systemName: busMapVM.cameraLockToBus ? "location.fill" : "location")
                    }
                }
                // Title
                Text("\(combineMapListVM.description?.routeNumber ?? "") \(Image(systemName: "chevron.forward.circle.fill")) \(busMapVM.stops.last?.name ?? "")")
            }
            .padding()
            .background()
            HStack {
                Spacer()
                Text("Last update: \(lastUpdatedDate())")
                Spacer()
            }
            .foregroundStyle(.white)
            .background(combineMapListVM.internetConnection ? .green : .red)
        }
    }
    
    
    private func updateCameraPosition() {
        withAnimation {
            guard let newCameraPosition = busMapVM.newCameraPosition(), busMapVM.cameraLockToBus else {
                return
            }
            combineMapListVM.cameraPosition = newCameraPosition
        }
    }
    
    
    private func lastUpdatedDate() -> String {
        guard let updateDate = (combineMapListVM.vehicle?.gps?.lastUpdated ?? "").toDate() else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: updateDate)
    }
}

#Preview {
    BusMapTitleBar()
        .environmentObject(CombineMapListViewModel(mock: true))
        .environmentObject(BusMapViewModel())
}
