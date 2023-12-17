//
//  BusMapTitleBar.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import SwiftUI

struct BusMapTitleBar: View {
    @EnvironmentObject var combineMapListVM: TripViewModel
    @EnvironmentObject var busMapVM: BusMapViewModel
    @Environment(\.dismiss) var dissmiss
    
    var body: some View {
        // Title bar
        VStack(spacing: 0) {
            ZStack {
                // Buttons
                HStack {
                    // Back button
                    Button {
                        dissmiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                    }
                    Spacer()
                    // Map camera follow bus location button
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
            
            // Bus GPS last updated date
            HStack {
                Spacer()
                Button {
                    if !combineMapListVM.internetConnection {
                        combineMapListVM.bannerMessageType = .MoreInfo
                        combineMapListVM.showBanner = true
                    }
                } label: {
                    Text("Last update: \(lastUpdatedDate())")
                }
                Spacer()
            }
            .foregroundStyle(.white)
            .background(combineMapListVM.internetConnection ? .green : .red)
        }
    }
    
    /// Updates the camera position of the map with animation based on the new camera position calculated by the `busMapVM`.
    private func updateCameraPosition() {
        withAnimation {
            // Check if new camera position is available
            guard let newCameraPosition = busMapVM.newCameraPosition() else {
                return
            }
            // Set the camera position to the new value
            combineMapListVM.cameraPosition = newCameraPosition
        }
    }

    /// Returns the last updated date of the vehicle's GPS data as a formatted string.
    /// - Returns: A formatted string representing the last updated date, or an empty string if the date is not available.
    private func lastUpdatedDate() -> String {
        guard let updateDate = (combineMapListVM.vehicle?.gps?.lastUpdated ?? "").toDate() else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Format the update date to a custom string format
        return dateFormatter.string(from: updateDate)
    }
}

#Preview {
    BusMapTitleBar()
        .environmentObject(TripViewModel(mock: true))
        .environmentObject(BusMapViewModel())
}
