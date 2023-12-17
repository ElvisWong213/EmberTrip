//
//  HomeViewModel.swift
//  EmberTrip
//
//  Created by Elvis on 16/12/2023.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    /// An array of quotes fetched from the API or mock data.
    @Published var quotes: [Quotes] = []
    
    /// A boolean value that indicates whether an error message should be shown.
    @Published var showErrorMessage = false
    
    /// A boolean value that indicates whether there is cached data available.
    @Published var hadCacheData = false
        
    /// A boolean flag to indicate whether to use mock data.
    private var mock = false
        
    /// Initializes the HomeViewModel with default values.
    init() {
    }
    
    /// Initializes the HomeViewModel with mock data based on the provided flag.
    /// - Parameter mock: A boolean value representing whether to use mock data.
    init(mock: Bool) {
        self.mock = mock
        self.quotes = QuotesResponse.loadMockData()?.quotes ?? []
    }
    
    /// Fetches data from the API or mock data asynchronously.
    func getData() async {
        if mock {
            return
        }
        
        // Define time range for the request
        let from = Calendar.current.date(byAdding: .hour, value: -3, to: Date())
        let to = Calendar.current.date(byAdding: .hour, value: 3, to: Date())
        
        // Create quotes request object
        let request = QuotesRequest(destination: 42, origin: 13, departureDateFrom: from, departureDateTo: to)
        
        // Make a network request to fetch quotes
        do {
            let response = try await NetworkService.makeRequest(request: .getQuotes(quotesRequest: request)) as QuotesResponse
            quotes = response.quotes
        } catch {
            print(error.localizedDescription)
            showErrorMessage = true
        }
        
        // Check for cached data after fetching new data
        checkCacheData()
    }
    
    /// Checks if there is cached data available and updates the `hadCacheData` property.
    func checkCacheData() {
        hadCacheData = (FileManageService.loadDataFormCache() != nil)
    }
}
