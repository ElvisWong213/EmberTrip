//
//  BusStopView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI

struct BusStopView: View {
    @EnvironmentObject var combineMapListViewModel: CombineMapListViewModel
    @State private var showActualTime = false
    @State private var routes: [Route] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach(routes) { route in
                    BusStopInformationRow(scheduled: route.departure.scheduled, estimated: route.departure.estimated, location: route.location.name, showActualTime: showActualTime)
                }
            }
            .overlay {
                if routes.isEmpty {
                    Text("Oops, looks like there's no data...")
                }
            }
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
        }
        .onChange(of: combineMapListViewModel.routes) { oldValue, newValue in
            if let newValue = newValue {
                routes = newValue
            }
        }
        .onAppear() {
            if let rotues = combineMapListViewModel.routes {
                routes = rotues
            }
        }
    }
}

#Preview {
    BusStopView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
