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
        guard let userEmail = UserDefaults.standard.string(forKey: Cache.email)?.safeDatabaseKey() else {return}
        
        //inserting tweet id in the tweet's user's metadata
        database.child("users").child(userEmail).child("tweetIds").observeSingleEvent(of: .value) {[weak self] snapshot in
            guard var tweetIds = snapshot.value as? [String] else {
                let tweetIds = [model.tweetId]
                self?.database.child("users").child(userEmail).child("tweetIds").setValue(tweetIds) { error, _ in
                    completion(error == nil)
                }
                return
            }
            tweetIds.append(model.tweetId ?? "")
            self?.database.child("users").child(userEmail).child("tweetIds").setValue(tweetIds) { error, _ in
                completion(error == nil)
            }
        }
        
        //inserting tweet in the tweet collection
        database.child("tweets").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var tweetDictionary = snapshot.value as? [String: Any] else {
                let tweetDictionary =
                    [
                        model.tweetId:
                            [
                                "username": model.username,
                                "userHandle": model.userHandle,
                                "text": model.text
                            ]
                    ]
                self?.database.child("tweets").setValue(tweetDictionary) { error, _ in
                    completion(error == nil)
                }
                return
            }
            tweetDictionary[model.tweetId ?? ""] =
                [
                    "username": model.username,
                    "userHandle": model.userHandle,
                    "text": model.text
                ]
            self?.database.child("tweets").setValue(tweetDictionary, withCompletionBlock: { error, _ in
                completion(error == nil)
            })
        }
    }
    
    ///Fetches a User's username from the DB
    ///- Parameters
    ///- email
    ///- completion: Async callback for result as a Result
    public func getUsername(email: String, completion: @escaping (Result<String, Error>) -> Void){
        var username: String = ""
        let key = email.safeDatabaseKey()
        database.child("users").child(key).child("username").getData { error, snapshot in
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
        database.child("users").child(key).child("userHandle").getData { error, snapshot in
            guard error == nil else {
                completion(.failure(APIError.failedtoGetData))
                return;
            }
            userHandle = snapshot.value as? String ?? "unknown user handle"
            completion(.success(userHandle))
        }
    }
    
    func getTweets(completion: @escaping (Result<[TweetModel], Error>) -> Void) {
        database.child("tweets").observeSingleEvent(of: .value) { snapshot in
            guard let tweets = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(APIError.failedtoGetData))
                return
            }
            let tweetModels: [TweetModel] = tweets.compactMap({
                return TweetModel(
                    tweetId: $0.key,
                    username: $0.value["username"] as? String ,
                    userHandle: $0.value["userHandle"] as? String,
                    userEmail: nil,
                    userAvatar: nil,
                    text: $0.value["text"] as? String,
                    isLikedByUser: nil,
                    isRetweetedByUser: nil,
                    likes: nil,
                    retweets: nil,
                    comments: nil ,
                    dateCreated: nil
                )
            })
            completion(.success(tweetModels))
        }
    }
    
//MARK: - Private Methods
    
  
}
