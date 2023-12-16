//
//  HomeViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var quotes: [Quotes] = []
    @Published var showErrorMassage = false
    @Published var hadCacheData = false
    
    private var mock = false
    
    init() {
        
    }
    
    init(mock: Bool) {
        self.mock = mock
        self.quotes = QuotesResponse.loadMockData()?.quotes ?? []
    }
    
    func getData() async {
        if mock {
            return
        }
        let form = Calendar.current.date(byAdding: .hour, value: -3, to: Date.now)
        let to = Calendar.current.date(byAdding: .hour, value: 3, to: Date.now)
        let requset = QuotesRequest(destination: 42, origin: 13, departureDateFrom: form, departureDateTo: to)
        do {
            let response = try await NetworkService.makeRequest(request: .getQuotes(quotesRequest: requset)) as QuotesResponse
            quotes = response.quotes
        } catch {
            print(error)
            showErrorMassage = true
        }
        hadCacheData = (FileManageService.loadDataFormCache() != nil)
    }
    
}
