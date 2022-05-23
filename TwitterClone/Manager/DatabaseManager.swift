//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseDatabase

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
//MARK: - Public Methods
    
    /// Check if username and email is available
    /// - Parameters
    /// - email: String representing email
    /// - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        
        completion(true)
    }
    
    /// Inserts new user to DB
    /// - Parameters
    /// - email: String representing email
    /// - username: String representing username
    /// - completion: Async callback for result if database entry succeeded
    public func insertNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        //The DB doesnt like "." or "@" in key values so we have to replace those with "-" in the String extension
        let key = email.safeDatabaseKey()
        database.child(key).setValue(["username": username]) { error, _ in
            if error == nil {
                //succeeded
                completion(true)
                return
            }
            else {
                //failed
                completion(false)
                return
            }
        }
    }
    
//MARK: - Private Methods
    
  
}
