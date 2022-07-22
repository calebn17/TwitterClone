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

final class DatabaseManager {

//MARK: - Properties
    static let shared = DatabaseManager()
    private let firestore = Firestore.firestore()
    
    private var userRef: CollectionReference {
        return firestore.collection("users")
    }
    private var tweetRef: CollectionReference {
        return firestore.collection("tweets")
    }
    public var currentUser: User {
        return User(
            id: nil,
            userName: UserDefaults.standard.string(forKey: Cache.username) ?? "",
            userHandle: UserDefaults.standard.string(forKey: Cache.userHandle) ?? "",
            userEmail: UserDefaults.standard.string(forKey: Cache.email) ?? ""
        )
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
    func insertUser(
        newUser: User,
        completion: @escaping (Bool) -> Void) {
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
                print(email)
                let user = users.first(where: {$0.userEmail == email})
                continuation.resume(returning: user)
            }
        })
        return user
    }
    
    func getUserInfo(user: User) async throws -> ProfileHeaderViewModel? {
        let result: ProfileHeaderViewModel? = try await withCheckedThrowingContinuation({ continuation in
            userRef.document(user.userName).getDocument { snapshot, error in
                guard let info = snapshot?.data(),
                      error == nil else {
                          continuation.resume(throwing: error!)
                          return
                      }
                continuation.resume(returning: ProfileHeaderViewModel(with: info))
            }
        })
        return result
    }
    
    func insertUserInfo(info: ProfileHeaderViewModel, completion: @escaping (Bool) -> Void) {
        guard let data = info.asDictionary() else {
            completion(false)
            return
        }
        userRef.document(info.userName).setData(data) { error in
            completion(error == nil)
        }
    }
    
//MARK: - Tweets
    func insertTweet(
        with tweet: TweetModel,
        completion: @escaping (Bool) -> Void) {
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
        return resultTweets.sorted { tweet1, tweet2 in
            guard let date1 = tweet1.dateCreatedString,
                  let date2 = tweet2.dateCreatedString
            else {return false}
            return date1 > date2
        }
    }
    
    func getTweet(with id: String) async throws -> TweetModel? {
        let resultTweet: TweetModel? = try await withCheckedThrowingContinuation({ continuation in
            tweetRef.document(id).getDocument { snapshot, error in
                guard let tweetData = snapshot?.data(),
                      error == nil
                else {
                    continuation.resume(throwing: error!)
                    return
                }
                continuation.resume(returning: TweetModel(with: tweetData))
            }
        })
        return resultTweet
    }

//MARK: - Like
    
    enum LikeStatus {
        case liked
        case unliked
    }
    
    func updateLikeStatus(
        type: LikeStatus,
        tweet: TweetModel,
        completion: @escaping (Bool) -> Void) {
            
            let ref = tweetRef.document(tweet.tweetId)
            
            Task {
                do {
                    guard var tweetModel = try await getTweet(with: tweet.tweetId) else {
                        completion(false)
                        return
                    }
                    switch type {
                    case .liked:
                        if !tweetModel.likers.contains(currentUser.userName) {
                            tweetModel.likers.append(currentUser.userName)
                        }
                    case .unliked:
                        if tweetModel.likers.contains(currentUser.userName) {
                            tweetModel.likers.removeAll(where: {$0 == currentUser.userName})
                        }
                    }
                    try await ref.setData(tweetModel.asDictionary() ?? [:] )
                    completion(true)
                }
                catch {
                    print("Could not update like status: \(error.localizedDescription)")
                }
            }
        }

//MARK: - Retweet
    enum RetweetStatus {
        case retweeted
        case notRetweeted
    }
    
    func updateRetweetStatus(
        type: RetweetStatus,
        tweet: TweetModel,
        completion: @escaping (Bool) -> Void) {
            
            let ref = tweetRef.document(tweet.tweetId)
            
            Task {
                do {
                    guard var tweetModel = try await getTweet(with: tweet.tweetId) else {
                        completion(false)
                        return
                    }
                    switch type {
                    case .retweeted:
                        if !tweetModel.retweeters.contains(currentUser.userName) {
                            tweetModel.retweeters.append(currentUser.userName)
                        }
                    case .notRetweeted:
                        if tweetModel.retweeters.contains(currentUser.userName) {
                            tweetModel.retweeters.removeAll(where: {$0 == currentUser.userName})
                        }
                    }
                    try await ref.setData(tweetModel.asDictionary() ?? [:] )
                    completion(true)
                }
                catch {
                    print("Could not update retweet status: \(error.localizedDescription)")
                }
            }
        }
    
//MARK: - Comment
    func insertComment(tweetId: String, text: String, completion: @escaping (Bool) -> Void) {
        let ref = tweetRef.document(tweetId)
        ref.getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(),
                  error == nil
            else {
                completion(false)
                return
            }
            var tweet = TweetModel(with: data)
            tweet?.comments.append(
                TweetModel(
                    tweetId: UUID().uuidString,
                    username: self?.currentUser.userName,
                    userHandle: self?.currentUser.userHandle,
                    userEmail: self?.currentUser.userEmail,
                    userAvatar: nil,
                    text: text,
                    likers: [],
                    retweeters: [],
                    comments: [],
                    dateCreatedString: String.date(from: Date())
                )
            )
            ref.setData(tweet?.asDictionary() ?? [:])
            completion(true)
        }
    }
    
//MARK: - Notifications
   
    func insertNotifications(of type: NotificationActions, tweet: TweetModel, completion: @escaping (Bool) -> Void ) {
        guard let receiverUsername = tweet.username else {
            completion(false)
            return
        }
        let notificationId = UUID().uuidString
        
        let ref = userRef.document(receiverUsername).collection("notifications").document(notificationId)
        guard let data = NotificationsViewModel(
            senderUserName: currentUser.userName,
            action: type.rawValue,
            model: tweet,
            dateString: String.date(from: Date()) ?? Date().timeIntervalSince1970.formatted()
        ).asDictionary() else {
            completion(false)
            return
        }
        
        ref.setData(data) { error in
            completion(error == nil)
        }
    }
    
    func getNotifications() async throws -> [NotificationsViewModel] {
        let ref = userRef.document(currentUser.userName).collection("notifications")
        
        let result: [NotificationsViewModel] = try await withCheckedThrowingContinuation({ continuation in
            ref.getDocuments { snapshot, error in
                guard let notifications = snapshot?.documents.compactMap({NotificationsViewModel(with: $0.data())}),
                      error == nil else {
                          continuation.resume(throwing: error!)
                          return
                      }
                continuation.resume(returning: notifications)
            }
        })
        return result
    }
}
