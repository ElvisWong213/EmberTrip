//
//  RoutesListView.swift
//  EmberTrip
//
//  Created by Elvis on 13/12/2023.
//

import SwiftUI

struct RoutesListView: View {   
    @State var quotes: [Quotes] = []
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(quotes) { quote in
                    NavigationLink {
                        BusStopView(tripId: quote.legs?[0].tripUid ?? "")
                    } label: {
                        BusStopInformationRow(scheduled: quote.legs?[0].departure?.scheduled, estimated: quote.legs?[0].departure?.estimated, location: quote.legs?[0].destination?.name, showActualTime: true)
                    }
                }
            }
            .navigationTitle("From: \(quotes[0].legs?[0].origin?.name ?? "")")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            let form = Date.now
            let to = Calendar.current.date(byAdding: .hour, value: 1, to: Date.now)
            let requset = QuotesRequest(destination: 42, origin: 13, departureDateFrom: form, departureDateTo: to)
            do {
                let response = try await NetworkService.makeRequest(request: .getQuotes(quotesRequest: requset)) as QuotesResponse
                quotes = response.quotes
                print(response)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    RoutesListView(quotes: QuotesResponse.loadMockData()?.quotes ?? [])
}
