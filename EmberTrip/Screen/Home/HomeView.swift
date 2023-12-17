//
//  HomeView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.quotes) { quote in
                    NavigationLink {
                        TripView(tripId: quote.legs?[0].tripUid ?? "")
                    } label: {
                        BusStopInformationRow(scheduled: quote.legs?[0].departure?.scheduled, 
                                              estimated: quote.legs?[0].departure?.estimated,
                                              location: quote.legs?[0].destination?.name,
                                              showActualTime: true)
                    }
                }
                // Prevoius session
                if viewModel.hadCacheData {
                    Section("") {
                        NavigationLink {
                            TripView(tripId: "")
                        } label: {
                            Text("Previous Session")
                        }
                    }
                }
            }
            .navigationTitle("From: \(viewModel.quotes.first?.legs?.first?.origin?.name ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                await viewModel.getData()
            }
        }
        .banner(showBanner: $viewModel.showErrorMessage, messageType: .NetworkError)
        .task {
            await viewModel.getData()
        }
        .onAppear() {
            viewModel.checkCacheData()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(mock: true))
}
