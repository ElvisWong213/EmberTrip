//
//  ContentView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI

struct ContentView: View {
    @State var quotes: [Quotes] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(quotes) { quote in
                    NavigationLink {
                        CombineMapListView(tripId: quote.legs?[0].tripUid ?? "")
                    } label: {
                        BusStopInformationRow(scheduled: quote.legs?[0].departure?.scheduled, 
                                              estimated: quote.legs?[0].departure?.estimated,
                                              location: quote.legs?[0].destination?.name,
                                              showActualTime: true)
                    }
                }
            }
            .overlay{
                if quotes.isEmpty {
                    ProgressView()
                }
            }
            .navigationTitle("From: \(quotes.first?.legs?.first?.origin?.name ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                getData()
            }
        }
        .onAppear() {
            getData()
        }
    }
    
    private func getData() {
        Task {
            let form = Calendar.current.date(byAdding: .hour, value: -2, to: Date.now)
            let to = Calendar.current.date(byAdding: .hour, value: 2, to: Date.now)
            let requset = QuotesRequest(destination: 42, origin: 13, departureDateFrom: form, departureDateTo: to)
            do {
                let response = try await NetworkService.makeRequest(request: .getQuotes(quotesRequest: requset)) as QuotesResponse
                quotes = response.quotes
                print(response)
            } catch {
                print(error)
                print(NetworkService.internetConnectionLost)
            }
        }
    }
}

#Preview {
    ContentView(quotes: QuotesResponse.loadMockData()?.quotes ?? [])
}
