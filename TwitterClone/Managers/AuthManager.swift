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
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping ((Bool) -> Void)) {
        if let email = email {
            //email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    //failed to login
                    completion(false)
                    return
                }
                //successfully logged in
                UserDefaults.standard.set(username, forKey: "username")
                completion(true)
            }
        }
        else if let username = username {
            //username login
            print(username)
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
