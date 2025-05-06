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
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@", username)
        
        if let users = try? context.fetch(request), !users.isEmpty {
            return false // username already exists
        }
        
        let user = User(context: context)
        user.name = name
        user.username = username
        user.password = password
        
        CoreDataManager.shared.saveContext()
        return true
    }
    
    func loginUser(username: String, password: String) -> User? {
        let context = CoreDataManager.shared.context
        
        let request = NSFetchRequest<User>(entityName: "User")
        request.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
        
        if let users = try? context.fetch(request), let user = users.first {
            return user
        }
        return nil
    }
    
    func getCurrentUser() -> User? {
        guard let username = UserDefaults.standard.string(forKey: "loggedInUsername") else {
            return nil
        }

        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "username == %@", username)

        return try? context.fetch(request).first
    }
    
    func fetchFavorites() -> [Cat] {
        guard let currentUser = getCurrentUser() else {
            return []
        }

        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user.username == %@", currentUser.username ?? "")

        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites.map {
                Cat(id: $0.id ?? "", url: $0.url ?? "", breeds: nil)
            }
        } catch {
            print("Failed to fetch favorites:", error)
            return []
        }
    }
    
    func saveFavorite(isFavorite: Bool, cat: Cat?) {
        guard let favCat = cat else { return }
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND user.username == %@", favCat.id, getCurrentUser()?.username ?? "")
        
        if isFavorite {
            do {
                // Check if already exists
                let existing = try context.fetch(fetchRequest)
                if !existing.isEmpty {
                    return
                }

                let favorite = Favorite(context: context)
                favorite.id = favCat.id
                favorite.url = favCat.url
                favorite.user = getCurrentUser()
                try context.save()
                print("Success to save favorite.")
            } catch {
                print("Failed to save favorite:", error)
            }

        } else {
            if getCurrentUser() != nil {
                do {
                    let results = try context.fetch(fetchRequest)
                    for object in results {
                        context.delete(object)
                    }
                    try context.save()
                    print("Favorite removed successfully.")
                } catch {
                    print("Failed to remove favorite:", error)
                }
            }
        }
    }
}
