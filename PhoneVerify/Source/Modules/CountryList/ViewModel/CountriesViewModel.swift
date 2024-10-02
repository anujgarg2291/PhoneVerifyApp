//
//  CountriesViewModel.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
import Combine
class CountriesViewModel: ObservableObject {
    @Published var countries: [String: Country] = [:]  // Dictionary with country code as key and Country as value
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()

    func fetchCountries() {
        apiService.fetchCountries()
            .receive(on: DispatchQueue.main)  // Ensure the result is received on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Print the error and update errorMessage
                    DispatchQueue.main.async {
                        debugPrint("Error occurred: \(error.localizedDescription)")
                        self.errorMessage = error.localizedDescription
                    }
                case .finished:
                    // Request completed successfully
                    debugPrint("Fetch Countries request finished")
                }
            }, receiveValue: { response in
               self.countries = response.countries
            })
            .store(in: &cancellables)
    }
}
