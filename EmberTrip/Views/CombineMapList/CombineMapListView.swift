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
        if tripId == "" {
            self._viewModel = StateObject(wrappedValue: CombineMapListViewModel(mock: true))
        } else {
            self._viewModel = StateObject(wrappedValue: CombineMapListViewModel(tripId: tripId))
        }
    }

    var body: some View {
        VStack {
            BusMapView()
                .sheet(isPresented: .constant(true), content: {
                    BusStopView()
                        .presentationDetents([.fraction(1), .fraction(0.4)])
                        .presentationBackgroundInteraction(.enabled)
                        .interactiveDismissDisabled()
                    
                })
        }
        .environmentObject(viewModel)
        .onReceive(timer, perform: { _ in
            viewModel.getData()
        })
        .onAppear() {
            viewModel.getData()
        }
    }
}

#Preview {
    CombineMapListView(tripId: "")
}
