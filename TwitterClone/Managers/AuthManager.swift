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
            //successfully logged in
            //fetching username and handle
            DatabaseManager.shared.getUsername(email: email) { result in
                switch result {
                case .success(let username):
                    UserDefaults.standard.set(username, forKey: Cache.username)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            DatabaseManager.shared.getUserHandle(email: email) { result in
                switch result {
                case .success(let handle):
                    UserDefaults.standard.set(handle, forKey: Cache.userHandle)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            UserDefaults.standard.set(email, forKey: Cache.email)
            completion(true)
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
