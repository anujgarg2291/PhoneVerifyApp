//
//  Country.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
struct Country: Codable {
    let name: String
    let diallingCode: String

    enum CodingKeys: String, CodingKey {
        case name = "country_name"
        case diallingCode = "dialling_code"
    }
}

struct CountryResponse: Codable {
    let countries: [String: Country]  // Country code as key, and Country details as value

    // Custom initializer to decode dynamic dictionary keys
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempCountries = [String: Country]()

        for key in container.allKeys {
            // Decode the Country for each key (country code)
            let country = try container.decode(Country.self, forKey: key)
            tempCountries[key.stringValue] = country
        }

        self.countries = tempCountries
    }
    
    
    // Additional initializer to allow manual creation of CountryResponse from a dictionary
    init(countries: [String: Country]) {
        self.countries = countries
    }
}

// Dynamic coding key to handle country code as key
struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    init?(intValue: Int) {
        return nil
    }
}
