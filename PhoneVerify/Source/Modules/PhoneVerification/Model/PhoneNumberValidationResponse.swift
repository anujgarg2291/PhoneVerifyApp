//
//  PhoneNumberValidationResponse.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
struct PhoneNumberValidationResponse: Codable {
    let valid: Bool
    let number: String
    let international_format: String
    let country_name: String
    let location: String?
    let carrier: String?
    let line_type: String?
}
