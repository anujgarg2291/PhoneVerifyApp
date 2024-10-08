# Phone Validator
This is an iOS application for validating phone numbers using country codes. The app allows users to select a country code from a list, enter a phone number, and validate it using an API. If the phone number is valid, the information is saved in a local database, and the data is fetched and displayed. If the phone number is invalid, it won’t be saved.

**Features**


	•	Country Code Selection: Users can select a country code from a list of countries. The selected code is applied to the phone number for validation.

	•	Phone Number Validation: After entering a phone number, users can validate the number by clicking the “Validate” button.

	•	Search Feature: In the country list, users can search for a specific country name using the search bar.

	•	Local Database: If the phone number is valid, the phone number, carrier, and location are stored in a local database.

	•	API Call: The app uses an API to validate the phone number and retrieve carrier and location details.

	•	SwiftUI & Combine: Built using SwiftUI and Combine framework.


 **Screenshots**
 

<img width="327" alt="Screenshot 2024-10-08 at 12 56 33 PM" src="https://github.com/user-attachments/assets/4df0ca81-99ec-4375-a466-c31b31510442">

<img width="323" alt="Screenshot 2024-10-08 at 12 56 56 PM" src="https://github.com/user-attachments/assets/6bf8e8da-1dfb-466d-aef5-9f4ad5b71ece">



**Requirements**

	•	iOS Deployment Target: 14.0

	•	Language: Swift

	•	Framework: SwiftUI, Combine

 **Installation**

 	1.	Clone the repository to your local machine.
  		git clone https://github.com/yourusername/PhoneValidatorApp.git

	2.	Open the project in Xcode.

	3.	Build and run the project on an iOS device or simulator.


 **Usage**

	1.	On the main screen, click on the country code field to open the list of countries.

	2.	Select a country from the list. You can use the search bar to quickly find a country.
 
	3.	Enter the phone number and click “Validate”.

	4.	If the phone number is valid, the details (carrier and location) will be saved in the local database.

	5.	If the phone number is invalid, no data will be saved. 

**API Integration**

The app makes an API call to validate the phone number. If the number is valid, it retrieves details like the carrier and location. 


**How It Works**

When the “Validate” button is clicked, the app triggers the following flow:

1.	Input Validation:

	•	The app first checks whether the country code and phone number fields are filled.

	•	If any field is empty, an appropriate error message is displayed.

2.	API Call:


   	•	After the user enters the phone number and selects the country code, the app removes the + symbol from the country code (if present) and constructs the complete phone number.

   	•	The app then calls the validatePhoneNumber function from the APIService to validate the number using the apilayer API.

Here’s the method that calls the API:

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


**3.	Handle the Response:**

	•	If the phone number is valid, the response is stored in the local database, and the carrier and location details are displayed to the user.
	•	If the phone number is invalid, an error message is shown and no data is saved. 

**Architecture** 

This project follows the MVVM (Model-View-ViewModel) architecture pattern, ensuring a clean separation of concerns and modular structure:

•	APIManager: Contains the APIService, responsible for handling all API calls and network requests.

•	Constant: Stores global constants used throughout the project.

•	DataStore: Manages data persistence, including models like PhoneValidationModel and the PersistenceController.

•	Modules: Organized by feature, each module follows the MVVM structure:

		•Model: Represents the data layer (e.g., PhoneNumberValidationResponse, Country).
		•ViewModel: Handles the business logic and prepares data for the View (e.g., PhoneValidationViewModel, CountriesViewModel).
		•View: UI components that bind to ViewModels (e.g., PhoneValidationView, CountryListView).
  
•	PhoneVerifyApp: The main application logic and entry point.

•	Preview Content: Used for SwiftUI previews and mock data.

•	PhoneVerifyTests: Contains unit tests to ensure the correct behavior of the app’s logic.



**License**

This project is licensed under the MIT License. See the LICENSE file for details.




