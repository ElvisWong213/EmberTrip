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

    var body: some View {
        if let routes = combineMapListViewModel.tripInfo?.route {
            NavigationStack {
                List {
                    ForEach(routes) { route in
                        BusStopInformationRow(scheduled: route.departure.scheduled, estimated: route.departure.estimated, location: route.location.name, showActualTime: showActualTime)
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
        }
    }
}

#Preview {
    BusStopView()
        .environmentObject(CombineMapListViewModel(mock: true))
}
