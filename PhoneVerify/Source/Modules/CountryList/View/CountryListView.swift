//
//  CountryListView.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import SwiftUI

struct CountryListView: View {
    @ObservedObject var viewModel = CountriesViewModel()
    @Binding var selectedCountryCode: String
    @Environment(\.presentationMode) var presentationMode  // This is used to dismiss the view
    @State private var searchText: String = ""  // State for the search text
    @State private var isLoading = false  // State to track loading status
    
    var body: some View {
        VStack {
            // Search Bar
            TextField(Constants.CountryList.searchPlaceholder, text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Show loader if data is loading, otherwise show the list
            if isLoading {
                Spacer()  // Push the loader to the middle of the view
                ProgressView(Constants.CountryList.loadingMessage) // This shows a loading spinner with text
                    .padding()
                Spacer()  // Keep the loader centered
            } else {
                // Country List
                List {
                    ForEach(filteredCountries, id: \.key) { countryCode, country in
                        Button(action: {
                            // Update the selected country with the dialling code
                            selectedCountryCode = country.diallingCode
                            // Dismiss the view after selecting the country
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            VStack(alignment: .leading) {
                                Text(country.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("\(Constants.CountryList.countryCodeLabel)\(countryCode)") // Display the country code from the dictionary key
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text("\(Constants.CountryList.diallingCodeLabel)\(country.diallingCode)") // Show the dialling code as well
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())  // Removes extra padding around the List
            }
        }
        .onAppear {
            loadCountries()
        }
        .navigationTitle(Constants.CountryList.navigationTitle)
        .edgesIgnoringSafeArea([.leading, .trailing])  // Makes the list take up the full width
        // Show error message if present
        if viewModel.countries.isEmpty , let error = viewModel.errorMessage {
            Text("\(Constants.CountryList.errorMessage) \(error)")
                .foregroundColor(.red)
                .padding()
        }
    }
    
    // Computed property to filter countries based on search text
    private var filteredCountries: [(key: String, value: Country)] {
        if searchText.isEmpty {
            return viewModel.countries.sorted(by: { $0.key < $1.key })
        } else {
            return viewModel.countries.filter {
                $0.value.name.lowercased().contains(searchText.lowercased())
            }.sorted(by: { $0.key < $1.key })
        }
    }
    
    // Function to load countries and show loader
    private func loadCountries() {
        isLoading = true  // Show loader when loading starts
        viewModel.fetchCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false  // Hide loader when loading ends
        }
    }
}
