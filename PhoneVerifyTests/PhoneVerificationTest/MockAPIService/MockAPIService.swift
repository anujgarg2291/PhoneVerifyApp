//
//  MockAPIService.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 03/10/24.
//

import Foundation
import Combine
class MockAPIService: APIServiceProtocol {
    var stubbedResponse: PhoneNumberValidationResponse?
    var stubbedError: Error?

    func validatePhoneNumber(_ number: String) -> AnyPublisher<PhoneNumberValidationResponse, Error> {
        if let error = stubbedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let response = stubbedResponse {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
    
    func fetchCountries() -> AnyPublisher<CountryResponse, Error> {
        // Use a predefined mock data for testing purposes
        let mockCountries : [String:Country] = [
            "US": Country(name: "United States", diallingCode: "+1"),
            "IN": Country(name: "India", diallingCode: "+91")
        ]
        
        // Create a mock CountryResponse object with the predefined mockCountries
        let mockResponse = CountryResponse(countries: mockCountries)
        
        // Return the mock response via a publisher
        return Just(mockResponse)
            .setFailureType(to: Error.self)  // Make it conform to the same type signature
            .eraseToAnyPublisher()
    }
}
