//
//  CombineMapListView.swift
//  EmberTrip
//
//  Created by Elvis on 14/12/2023.
//

import SwiftUI

struct CombineMapListView: View {
    @StateObject var viewModel: CombineMapListViewModel
    private let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    init(tripId: String) {
        if tripId == "MOCK" {
            self._viewModel = StateObject(wrappedValue: CombineMapListViewModel(mock: true))
        } else {
            self._viewModel = StateObject(wrappedValue: CombineMapListViewModel(tripId: tripId))
        }
    }

    var body: some View {
        VStack {
            if viewModel.routes != nil && viewModel.vehicle != nil {
                BusMapView()
                    .sheet(isPresented: .constant(true), content: {
                        BusStopsListView()
                            .presentationDetents([.fraction(0.8), .fraction(0.4), .fraction(0.1)])
                            .presentationBackgroundInteraction(.enabled)
                            .interactiveDismissDisabled()
                        
                    })
            } else {
                ProgressView()
            }
        }
        .banner(showBanner: $viewModel.showBanner, messageType: viewModel.bannerMessageType)
        .environmentObject(viewModel)
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
    CombineMapListView(tripId: "MOCK")
}
