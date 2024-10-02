//
//  ContentView.swift
//  PhoneVerify
//
//  Created by Anuj Garg on 02/10/24.
//

import SwiftUI
import SwiftUI

struct PhoneValidationView: View {
    @ObservedObject var viewModel = PhoneValidationViewModel()
    @State private var selectedCountryCode: String = ""
    @State private var isCountryPickerActive = false
    @State private var validatedResults: [PhoneNumberValidationResponse] = []
    @State private var showingAlert = false
    @State private var isLoading = false  // State to track loading
    
    var body: some View {
        NavigationView {
            VStack {
                // TextFields in a single row (HStack)
                HStack {
                    // NavigationLink to CountryListView
                    NavigationLink(destination: CountryListView(selectedCountryCode: $selectedCountryCode), isActive: $isCountryPickerActive) {
                        HStack {
                            // Fixed width for the selected country code
                            Text(selectedCountryCode.isEmpty ? Constants.Validation.countryCodePlaceholder : selectedCountryCode)
                                .padding()
                                .frame(width: 80)  // Set a fixed width for the text
                                .border(Color.black)
                                .foregroundColor(selectedCountryCode.isEmpty ? .gray : .black)
                        }
                    }
                    // Phone Number TextField
                    TextField(Constants.Validation.phoneNumberFieldPlaceholder, text: $viewModel.phoneNumber)
                        .padding()
                        .keyboardType(.numberPad)
                        .border(Color.black)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Display a list of validated phone numbers with no leading/trailing padding
                List(viewModel.fetchValidPhoneNumbers(), id: \.number) { result in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(Constants.Labels.number)
                                .bold()  // Bold label
                            Text(result.number ?? Constants.Validation.unknown)
                        }
                        HStack {
                            Text(Constants.Labels.carrier)
                                .bold()  // Bold label
                            Text(result.carrier ?? Constants.Validation.unknown)
                        }
                        HStack {
                            Text(Constants.Labels.location)
                                .bold()  // Bold label
                            Text(result.location ?? Constants.Validation.unknown)
                        }
                    }
                    .padding(.vertical, 8)  // Add vertical padding between rows
                    .background(Color.white)  // Background color for list items
                    .cornerRadius(8)  // Rounded corners for the list items
                }
                .listStyle(PlainListStyle())  // Remove default styling
                .listRowInsets(EdgeInsets())  // Remove extra padding in List rows
                
                Spacer()
                
                // Validate Button at the bottom
                Button(action: {
                    isLoading = true  // Start showing loader
                    viewModel.validateNumber(selectedCountryCode: selectedCountryCode)
                    
                    if let validationResult = viewModel.validationResponse {
                        validatedResults.append(validationResult)
                    }
                    
                    if let errMsg = viewModel.errorMessage {
                        debugPrint("Error Message::\(errMsg)")
                        showingAlert = true
                        debugPrint("Error Message showingAlert::\(showingAlert)")
                    }
                    
                    isLoading = false  // Stop showing loader once response is received
                }) {
                    Text(Constants.Validation.validateButtonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 18, weight: .bold))
                }
                .padding(.horizontal)
                .alert(isPresented: $showingAlert) {
                    return Alert(
                        title: Text(Constants.Validation.alertTitle),
                        message: Text(viewModel.errorMessage ?? ""),
                        dismissButton: .default(Text(Constants.Validation.ok))
                    )
                }
                
                // Loader view, conditionally displayed based on isLoading
                if isLoading {
                    ProgressView(Constants.Validation.validationInProgressText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                }
            }
            .padding(.bottom, 20)
            .navigationBarItems(leading: EmptyView()) // Hides default title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(Constants.Validation.phoneValidator)
                            .font(.system(size: 22))
                            .bold()
                    }
                }
            }
        }
    }
}
