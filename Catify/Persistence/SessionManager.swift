//
//  SessionManager.swift
//  Catify
//
//  Created by Dwistari on 05/05/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var isLoggedIn: Bool {
        return UserDefaults.standard.string(forKey: "loggedInUsername") != nil
    }
    
    func login(username: String) {
        UserDefaults.standard.set(username, forKey: "loggedInUsername")
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "loggedInUsername")
    }
}
