//
//  PersistenceController.swift
//  PhoneVerifyApp
//
//  Created by Anuj Garg on 02/10/24.
//

import Foundation
import CoreData
protocol PersistenceServiceProtocol {
    func saveValidatedPhoneNumber(_ response: PhoneNumberValidationResponse)
}
struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "PhoneValidationModel") // Replace with your model name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
