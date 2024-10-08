//
//  APIService.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
import Combine

// Define a protocol that declares the necessary methods
protocol APIServiceProtocol {
    func validatePhoneNumber(_ number: String) -> AnyPublisher<PhoneNumberValidationResponse, Error>
    func fetchCountries() -> AnyPublisher<CountryResponse, Error>
}


struct APIService: APIServiceProtocol {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
    private let baseURL = "https://apilayer.net/api"
    
    func validatePhoneNumber(_ number: String) -> AnyPublisher<PhoneNumberValidationResponse, Error> {
        debugPrint("Validate Phone Number API Called:::\(number)")
        let urlString = "\(baseURL)/validate?number=\(number)&access_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                // Print the raw response data
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    debugPrint("API Response JSON: \(jsonString)")
                }
            }, receiveCompletion: { completion in
                // Print any errors if they occur
                if case .failure(let error) = completion {
                    debugPrint("API Error: \(error.localizedDescription)")
                }
            })
            .map(\.data)
            .decode(type: PhoneNumberValidationResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchCountries() -> AnyPublisher<CountryResponse, Error> {
        let urlString = "\(baseURL)/countries?access_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        debugPrint("URL is \(urlString)")
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                // Print the raw response data
                
            }, receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // Print the error if it occurs
                    debugPrint("Error occurred: \(error.localizedDescription)")
                case .finished:
                    debugPrint("Request finished successfully")
                }
            })
            .map(\.data)
            .tryMap { data in
                do {
                    let decoded = try JSONDecoder().decode(CountryResponse.self, from: data)
                    return decoded
                } catch {
                    // Print detailed decoding error
                    debugPrint("Decoding error: \(error.localizedDescription)")
                    throw error
                }
            }
            .handleEvents(receiveOutput: { countryResponse in
                // Print the decoded countries if decoding succeeds
            })
            .eraseToAnyPublisher()
    }
}
