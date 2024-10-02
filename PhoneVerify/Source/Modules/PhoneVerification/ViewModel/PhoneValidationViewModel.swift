//
//  PhoneValidationViewModel.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
import Combine
import CoreData
import UIKit
class PhoneValidationViewModel: ObservableObject, PersistenceServiceProtocol {
    @Published var phoneNumber = ""
    @Published var validationResponse: PhoneNumberValidationResponse?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol  // Use protocol instead of concrete type
    private let context = PersistenceController.shared.context
    // Dependency injection
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func validateNumber(selectedCountryCode: String) {
        guard !selectedCountryCode.isEmpty else {
            self.errorMessage = Constants.AlertMessages.countryCodeEmpty
            return
        }
        
        guard !phoneNumber.isEmpty else {
            self.errorMessage = Constants.AlertMessages.phoneNumberEmpty
            return
        }
        
        // Remove the + sign from the selectedCountryCode
        let sanitizedCountryCode = selectedCountryCode.replacingOccurrences(of: "+", with: "")
        let number = sanitizedCountryCode + phoneNumber
        apiService.validatePhoneNumber(number)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                if !response.valid {
                    self.errorMessage = Constants.AlertMessages.phoneNumberInvalid
                } else {
                    self.validationResponse = response
                    self.errorMessage = nil
                    self.saveValidatedPhoneNumber(response)
                }
            })
            .store(in: &cancellables)
    }
    
    // Save the validated phone number to Core Data
    func saveValidatedPhoneNumber(_ response: PhoneNumberValidationResponse) {
        // Check if the phone number already exists in Core Data
        let fetchRequest: NSFetchRequest<ValidatedPhoneNumber> = ValidatedPhoneNumber.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %@", response.number)
        
        do {
            let existingNumbers = try context.fetch(fetchRequest)
            if existingNumbers.isEmpty {
                // If the phone number does not exist, save the new number
                let newPhoneNumber = ValidatedPhoneNumber(context: context)
                newPhoneNumber.number = response.number
                newPhoneNumber.internationalFormat = response.international_format
                newPhoneNumber.carrier = response.carrier
                newPhoneNumber.location = response.location
                newPhoneNumber.isValid = response.valid
                
                try context.save()
                debugPrint("Saved new phone number: \(response.number)")
            } else {
                
                debugPrint("\(Constants.AlertMessages.phoneNumberExists) :::\(response.number)")
            }
        } catch {
            debugPrint("Failed to save validated phone number: \(error.localizedDescription)")
        }
    }
    
    // Fetch valid phone numbers from Core Data
    func fetchValidPhoneNumbers() -> [ValidatedPhoneNumber] {
        let fetchRequest: NSFetchRequest<ValidatedPhoneNumber> = ValidatedPhoneNumber.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isValid == true")  // Only fetch valid numbers
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.reversed()
        } catch {
            debugPrint("Failed to fetch valid phone numbers: \(error.localizedDescription)")
            return []
        }
    }
}
