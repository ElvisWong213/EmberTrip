//
//  TripView.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI

struct TripView: View {
    @StateObject var viewModel: TripViewModel
    private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    init(tripId: String) {
        if tripId == "MOCK" {
            self._viewModel = StateObject(wrappedValue: TripViewModel(mock: true))
        } else {
            self._viewModel = StateObject(wrappedValue: TripViewModel(tripId: tripId))
        }
    }

    var body: some View {
        VStack {
            BusMapView()
            // Using sheet to show all the bus stops in a list
                .sheet(isPresented: .constant(true), content: {
                    BusStopsListView()
                        .presentationDetents([.fraction(0.8), .fraction(0.4), .fraction(0.1)])
                        .presentationBackgroundInteraction(.enabled)
                        .interactiveDismissDisabled()
                    
                })
        }
        .banner(showBanner: $viewModel.showBanner, messageType: viewModel.bannerMessageType)
        .environmentObject(viewModel)
        // Send a request every 10 seconds to make sure the bus location is updated
        .onReceive(timer) { _ in
            Task {
                await viewModel.getData()
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    TripView(tripId: "MOCK")
}
