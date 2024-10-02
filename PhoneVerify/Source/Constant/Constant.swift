//
//  Constant.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 03/10/24.
//

import Foundation

struct Constants {
    struct Validation {
        static let countryCodePlaceholder = "+111"
        static let phoneNumberFieldPlaceholder = "Phone Number"
        static let validateButtonText = "Validate"
        static let validationInProgressText = "Validating..."
        static let alertTitle = "Alert"
        static let unknownError = "Unknown error"
        static let unknown = "Unknown"
        static let phoneValidator = "Phone Validator"
        static let ok = "OK"
    }
    
    struct Labels {
        static let number = "Number:"
        static let carrier = "Carrier:"
        static let location = "Location:"
    }
    
    struct AlertMessages {
        static let phoneNumberExists = "Phone number already exists"
        static let phoneNumberInvalid = "Phone number is not valid with country code."
        static let countryCodeEmpty = "Country Code cannot be blank."
        static let phoneNumberEmpty = "Phone number cannot be blank."
    }
    
    struct CountryList {
            static let searchPlaceholder = "Search country"
            static let loadingMessage = "Loading countries..."
            static let navigationTitle = "Countries"
            static let countryCodeLabel = "Code: "
            static let diallingCodeLabel = "Dialling Code: "
            static let errorMessage = "Error: "
        }
}
