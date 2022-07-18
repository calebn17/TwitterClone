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
    
    public func registerNewUser(username: String, userHandle: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        //check if username is available
        //check if email is available
        DatabaseManager.shared.canCreateNewUser(with: email, username: username, userHandle: userHandle) { canCreate in
            if canCreate {
                //create account
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        //Firebase auth could not create account
                        completion(false)
                        return
                    }
                    //insert account to db
                    DatabaseManager.shared.insertUser(with: email, username: username, userHandle: userHandle) { inserted in
                        if inserted {
                            //successfully inserted to DB
                            UserDefaults.standard.set(email, forKey: Cache.email)
                            UserDefaults.standard.set(username, forKey: Cache.username)
                            UserDefaults.standard.set(userHandle, forKey: Cache.userHandle)
                            completion(true)
                            return
                        }
                        else {
                            //failed to insert to DB
                            print("failed to insert new user to DB")
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                //either username or email does not exist
                completion(false)
            }
        }
    }
    
    public func loginUser(email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                //failed to login
                completion(false)
                return
            }
            Task {
                do {
                    let username = try await DatabaseManager.shared.getUsername(email: email)
                    let userHandle = try await DatabaseManager.shared.getUserHandle(email: email)
                    UserDefaults.standard.set(username, forKey: Cache.username)
                    UserDefaults.standard.set(userHandle, forKey: Cache.userHandle)
                    UserDefaults.standard.set(email, forKey: Cache.email)
                    completion(true)
                }
                catch {
                    print("Error when retrieving username and handle")
                }
            }
        }
    }
    
    ///Attempt to Logout firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            completion(false)
            print(error)
            return
        }
    }
}
