//
//  DatabaseManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import UIKit

public class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let firestore = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return firestore.collection("users")
    }
    private var tweetRef: CollectionReference {
        return firestore.collection("tweets")
    }
    
    private init() {}

//MARK: - Users
    
    /// Check if username and email is available
    /// - Parameters
    /// - email: String representing email
    /// - username: String representing username
    func canCreateNewUser(with newUser: User, completion: (Bool) -> Void) {
        completion(true)
    }
    
    /// Inserts user to DB
    /// - Parameters
    /// - newUser: new user's User object
    func insertUser(newUser: User, completion: @escaping (Bool) -> Void) {
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
        userRef.document(newUser.userName).setData(data) { error in
            completion(error == nil)
        }
    }
  
    
    ///Fetches a User's username from the DB
    ///- Parameters
    ///- email
    func getUser(email: String) async throws -> User? {
        
        let user: User? = try await withCheckedThrowingContinuation({ continuation in
            userRef.getDocuments { snapshot, error in
                guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }),
                      error == nil
                else {return continuation.resume(throwing: APIError.failedtoGetData)}
                
                let user = users.first(where: {$0.userEmail == email})
                continuation.resume(returning: user)
            }
        })
        return user
    }
    
//MARK: - Tweets
    func insertTweet(with tweet: TweetModel, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: Cache.username) else {return}
        
        //inserting tweet id in the tweet's user's metadata
        guard let data = tweet.asDictionary() else {
            completion(false)
            return
        }
        userRef.document(username).collection("tweets").document(tweet.tweetId).setData(data) { error in
            completion(error == nil)
        }
        
        //inserting tweet in the tweet collection
        tweetRef.document(tweet.tweetId).setData(data) { error in
            completion(error == nil)
        }
    }
    
    ///Fetches Tweets from DB
    func getTweets() async throws -> [TweetModel] {
        let resultTweets: [TweetModel] = try await withCheckedThrowingContinuation({ continuation in
            tweetRef.getDocuments { snapshot, error in
                guard let tweets = snapshot?.documents,
                      error == nil
                else {
                    continuation.resume(throwing: error!)
                    return
                }
                let tweetModels = tweets.compactMap({ TweetModel(with: $0.data()) })
                continuation.resume(returning: tweetModels)
            }
        })
        return resultTweets
    }
}
