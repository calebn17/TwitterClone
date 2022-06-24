//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseDatabase
import UIKit

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    private init() {}
    
//MARK: - Public Methods
    
    /// Check if username and email is available
    /// - Parameters
    /// - email: String representing email
    /// - username: String representing username
    public func canCreateNewUser(with email: String, username: String, userHandle: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Inserts user to DB
    /// - Parameters
    /// - email: String representing email
    /// - username: String representing username
    /// - completion: Async callback for result if database entry succeeded
    public func insertUser(with email: String, username: String, userHandle: String, completion: @escaping (Bool) -> Void) {
        //The DB doesnt like "." or "@" in key values so we have to replace those with "-" in the String extension
        let userEmail = email.safeDatabaseKey()
        
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                //There are no users yet so we can just set the value
                let newUserDictionary =
                    [
                        userEmail: [
                            "username": username,
                            "userHandle": userHandle
                        ]
                    ]
                self?.database.child("users").setValue(newUserDictionary) { error, _ in
                    completion(error == nil)
                }
                return
            }
            //user collection already exists so lets add a new key:value into it
            usersDictionary[userEmail] = ["username": username, "userHandle": userHandle]
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                completion(error == nil)
            })
        }
    }
    
    func insertTweet(with model: TweetModel, completion: @escaping (Bool) -> Void) {
        
        //inserting tweet id in the tweet's user's metadata
        guard let userEmail = UserDefaults.standard.string(forKey: "username") else {return}
        database.child("users").child(userEmail).child("tweetIds").observeSingleEvent(of: .value) { snapshot in
            guard var tweetIdDictionary = snapshot.value as? [String: [String]] else {
                let tweetIdDictionary = ["tweetIds": [model.tweetId]]
                self.database.child("users").setValue(tweetIdDictionary) { error, _ in
                    completion(error == nil)
                }
                return
            }
            tweetIdDictionary["tweetIds"]?.append(model.tweetId ?? "")
            self.database.child("users").child("tweetIds").setValue(tweetIdDictionary) { error, _ in
                completion(error == nil)
            }
            
        }
        
        //inserting tweet in the tweet collection
        database.child("tweets").child("tweet").setValue([
            "tweetId": model.tweetId,
            "username": model.username ?? "",
            "userHandle": model.userHandle ?? "",
            "text": model.text ?? ""
        ]) { error, _ in
                
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
    
    ///Fetches a User's username from the DB
    ///- Parameters
    ///- email
    ///- completion: Async callback for result as a Result
    public func getUsername(email: String, completion: @escaping (Result<String, Error>) -> Void){
        var username: String = ""
        let key = email.safeDatabaseKey()
        database.child(key).child("username").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(APIError.failedtoGetData))
                return;
            }
            username = snapshot.value as? String ?? "unknown username"
            completion(.success(username))
        }
    }
    
    ///Fetches a User's handle from the DB
    ///- Parameters
    ///- email
    ///- completion: Async callback for result as a Result
    public func getUserHandle(email: String, completion: @escaping (Result<String, Error>) -> Void){
        var userHandle: String = ""
        let key = email.safeDatabaseKey()
        database.child(key).child("userHandle").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(APIError.failedtoGetData))
                return;
            }
            userHandle = snapshot.value as? String ?? "unknown user handle"
            completion(.success(userHandle))
        }
    }
    
//MARK: - Private Methods
    
  
}
