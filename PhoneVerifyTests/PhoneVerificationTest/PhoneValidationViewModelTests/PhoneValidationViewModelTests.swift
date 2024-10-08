//
//  PhoneVerifyTests.swift
//  PhoneVerifyTests
//
//  Created by Anuj Garg on 02/10/24.
//

import XCTest
import Combine
@testable import PhoneVerifyApp


class PhoneValidationViewModelTests: XCTestCase {
    
    var viewModel: PhoneValidationViewModel!
    var mockAPIService: MockAPIService!  // Mock instance of the API service
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        // Initialize the mock API service
        mockAPIService = MockAPIService()

        // Inject the mock API service into the view model
        viewModel = PhoneValidationViewModel(apiService: mockAPIService)

        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }

    // Test: Success scenario with valid phone number
    func testAPISuccess() {
        // Given a valid phone number and country code
        viewModel.phoneNumber = "1234567890"
        let validCountryCode = "+1"

        // Setup the stubbed response in the mock service
        let validResponse = PhoneNumberValidationResponse(valid: true, number: "1234567890", international_format: "+11234567890", country_name: "Carrier", location: "Location", carrier: "India", line_type: "mobile")
        mockAPIService.stubbedResponse = validResponse

        let expectation = self.expectation(description: "Valid API Response")

        // Act: Call validateNumber
        viewModel.validateNumber(selectedCountryCode: validCountryCode)

        // Assert: Check if the response is correctly handled
        viewModel.$validationResponse
            .dropFirst()  // Ignore initial value
            .sink { response in
                XCTAssertEqual(response?.number, "1234567890")
                XCTAssertNil(self.viewModel.errorMessage)  // No error should occur
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    // Test: Validation failure due to empty phone number
    func testValidationFailureWithEmptyPhoneNumber() {
        // Given an empty phone number and valid country code
        viewModel.phoneNumber = ""
        let validCountryCode = "+1"

        // Act: Call validateNumber
        viewModel.validateNumber(selectedCountryCode: validCountryCode)

        // Assert: Check that the validation fails due to empty phone number
        XCTAssertEqual(viewModel.errorMessage, "Phone number cannot be blank.")
    }

    // Test: Validation failure due to empty country code
    func testValidationFailureWithEmptyCountryCode() {
        // Given a valid phone number and empty country code
        viewModel.phoneNumber = "1234567890"
        let emptyCountryCode = ""

        // Act: Call validateNumber
        viewModel.validateNumber(selectedCountryCode: emptyCountryCode)

        // Assert: Check that the validation fails due to empty country code
        XCTAssertEqual(viewModel.errorMessage, "Country Code cannot be blank.")
    }

    // Test: API failure scenario
    func testAPIFailure() {
        // Given a valid phone number and country code
        viewModel.phoneNumber = "1234567890"
        let validCountryCode = "+1"

        // Setup the stubbed error in the mock service
        mockAPIService.stubbedError = NSError(domain: "TestError", code: 500, userInfo: nil)

        let expectation = self.expectation(description: "API Error")

        // Act: Call validateNumber
        viewModel.validateNumber(selectedCountryCode: validCountryCode)

        // Assert: Ensure the error message is set in the view model
        viewModel.$errorMessage
            .dropFirst()  // Ignore initial value
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "The operation couldn’t be completed. (TestError error 500.)")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
