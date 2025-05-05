//
//  CoreDataManager.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserData")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Saving error: \(error)")
        }
    }
    
    
    func registerUser(name: String, username: String, password: String) -> Bool {
        let context = CoreDataManager.shared.context
        
        // Check if email already exists
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@", username)
        
        if let users = try? context.fetch(request), !users.isEmpty {
            return false // Email already exists
        }
        
        let user = User(context: context)
        user.name = name
        user.username = username
        user.password = password
        
        CoreDataManager.shared.saveContext()
        return true
    }
    
    func loginUser(email: String, password: String) -> User? {
        let context = CoreDataManager.shared.context
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", email, password)
        
        if let users = try? context.fetch(request), let user = users.first {
            return user
        }
        return nil
    }
}
