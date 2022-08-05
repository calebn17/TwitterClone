//
//  AuthManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    private init() {}
    
//MARK: - Public Methods

    func registerNewUser(newUser: User, password: String) async throws {
        let allowed = try await DatabaseManager.shared.canCreateNewUser(with: newUser)
        if allowed {
            try await Auth.auth().createUser(withEmail: newUser.userEmail, password: password)
            try await DatabaseManager.shared.insertUser(newUser: newUser)
            UserDefaults.standard.set(newUser.userEmail, forKey: Cache.email)
            UserDefaults.standard.set(newUser.userName, forKey: Cache.username)
            UserDefaults.standard.set(newUser.userHandle, forKey: Cache.userHandle)
        }
    }
    
    public func loginUser(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
        guard let user = try await DatabaseManager.shared.getUser(email: email) else {return}
        UserDefaults.standard.set(user.userName, forKey: Cache.username)
        UserDefaults.standard.set(user.userHandle, forKey: Cache.userHandle)
        UserDefaults.standard.set(email, forKey: Cache.email)
    }
    
    ///Attempt to Logout firebase user
    public func logOut() async throws {
        try Auth.auth().signOut()
    }
}
