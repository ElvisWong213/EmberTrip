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
                        CombineMapListView(tripId: quote.legs?[0].tripUid ?? "")
                    } label: {
                        BusStopInformationRow(scheduled: quote.legs?[0].departure?.scheduled, 
                                              estimated: quote.legs?[0].departure?.estimated,
                                              location: quote.legs?[0].destination?.name,
                                              showActualTime: true)
                    }
                }
                if viewModel.hadCacheData {
                    Section("") {
                        NavigationLink {
                            CombineMapListView(tripId: "")
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
        .banner(showBanner: $viewModel.showErrorMassage)
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(mock: true))
}
