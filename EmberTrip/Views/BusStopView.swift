//
//  BusStopView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI

struct BusStopView: View {
    let tripId: String
    @State var routes: [Route] = []
    @State private var showActualTime = false

    var body: some View {
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
            .task {
                let requset = TripInfoRequest(id: tripId)
                do {
                    let response = try await NetworkService.makeRequest(request: .getTripInfo(tripInfoRequest: requset)) as TripInfoResponses
                    routes = response.route ?? []
                    print(response)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    BusStopView(tripId: "", routes: TripInfoResponses.loadMockData()?.route ?? [])
}
