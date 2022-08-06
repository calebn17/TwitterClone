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
    func canCreateNewUser(with newUser: User) async throws -> Bool {
        return true
    }
    
    /// Inserts user to DB
    /// - Parameters
    /// - newUser: new user's User object
    func insertUser(newUser: User) async throws {
        let newUserInfo = UserInfo(
            id: nil,
            userName: newUser.userName,
            userHandle: newUser.userHandle,
            userEmail: newUser.userEmail,
            bio: " ",
            followers: [],
            following: []
        )
        guard let data = newUserInfo.asDictionary() else {return}
        try await userRef.document(newUser.userName).setData(data)
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
    
    func getUserInfo(user: User) async throws -> UserInfo {
        let result: UserInfo = try await withCheckedThrowingContinuation({ continuation in
            userRef.document(user.userName).getDocument { snapshot, error in
                guard let data = snapshot?.data(),
                      let userInfo = UserInfo(with: data),
                      error == nil else {
                          continuation.resume(throwing: error!)
                          return
                      }
                continuation.resume(returning: userInfo)
            }
        })
        return result
    }
    
    func insertUserBio(bio: String) async throws {
        var userInfo = try await getUserInfo(user: currentUser)
        userInfo.bio = bio
        guard let data = userInfo.asDictionary() else {return}
        try await userRef.document(currentUser.userName).setData(data)
    }
    
//MARK: - Tweets
    func insertTweet(with tweet: TweetModel) async throws {
        guard let username = UserDefaults.standard.string(forKey: Cache.username) else {return}
        guard let data = tweet.asDictionary() else {return}
        try await userRef.document(username).collection("tweets").document(tweet.tweetId).setData(data)
        try await tweetRef.document(tweet.tweetId).setData(data)
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
    
    func updateLikeStatus(type: LikeStatus, tweet: TweetModel) async throws{
        let ref = tweetRef.document(tweet.tweetId)
        do {
            guard var tweetModel = try await getTweet(with: tweet.tweetId) else {return}
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
        }
        catch {
            print("Could not update like status: \(error.localizedDescription)")
        }
    }

//MARK: - Retweet
    enum RetweetStatus {
        case retweeted
        case unRetweeted
    }
    
    func updateRetweetStatus(type: RetweetStatus, tweet: TweetModel) async throws {
        let ref = tweetRef.document(tweet.tweetId)
        do {
            guard var tweetModel = try await getTweet(with: tweet.tweetId) else {return}
            switch type {
            case .retweeted:
                if !tweetModel.retweeters.contains(currentUser.userName) {
                    tweetModel.retweeters.append(currentUser.userName)
                }
            case .unRetweeted:
                if tweetModel.retweeters.contains(currentUser.userName) {
                    tweetModel.retweeters.removeAll(where: {$0 == currentUser.userName})
                }
            }
            try await ref.setData(tweetModel.asDictionary() ?? [:] )
        }
        catch {
            print("Could not update retweet status: \(error.localizedDescription)")
        }
    }
    
//MARK: - Comment
    func insertComment(tweetId: String, text: String) async throws {
        let ref = tweetRef.document(tweetId)
        let snapshot = try await ref.getDocument()
        guard let data = snapshot.data() else {return}
        
        var tweet = TweetModel(with: data)
        tweet?.comments.append(
            TweetModel(
                tweetId: UUID().uuidString,
                username: currentUser.userName,
                userHandle: currentUser.userHandle,
                userEmail: currentUser.userEmail,
                userAvatar: nil,
                text: text,
                likers: [],
                retweeters: [],
                comments: [],
                dateCreatedString: String(describing: Date().timeIntervalSince1970)
            )
        )
        try await ref.setData(tweet?.asDictionary() ?? [:])
    }
    
//MARK: - Notifications
   
    func insertNotifications(of type: NotificationActions, tweet: TweetModel) async throws {
        let receiverUsername = tweet.username
        let notificationId = UUID().uuidString
        
        let ref = userRef.document(receiverUsername).collection("notifications").document(notificationId)
        guard let data = NotificationsModel(
            senderUserName: currentUser.userName,
            action: type.rawValue,
            model: tweet,
            dateString: String(describing: Date().timeIntervalSince1970)
        ).asDictionary() else {return}
        
        try await ref.setData(data)
    }
    
    func getNotifications() async throws -> [NotificationsModel] {
        let ref = userRef.document(currentUser.userName).collection("notifications")
        
        let result: [NotificationsModel] = try await withCheckedThrowingContinuation({ continuation in
            ref.getDocuments { snapshot, error in
                guard let notifications = snapshot?.documents.compactMap({NotificationsModel(with: $0.data())}),
                      error == nil else {
                          continuation.resume(throwing: error!)
                          return
                      }
                continuation.resume(returning: notifications)
            }
        })
        return result
    }
    
//MARK: - Relationships
    
    func updateRelationship(targetUser: User, didFollow: Bool) async throws {
        
        if didFollow {
            Task {
                // Add current user to target user's followers list
                var targetUserInfo = try await getUserInfo(user: targetUser)
                targetUserInfo.followers.append(currentUser.userName)
                guard let targetUserData = targetUserInfo.asDictionary() else {return}
                try await userRef.document(targetUser.userName).setData(targetUserData)
                
                // Add target user to current user's following list
                var currentUserInfo = try await getUserInfo(user: currentUser)
                currentUserInfo.following.append(targetUser.userName)
                guard let currentUserData = currentUserInfo.asDictionary() else {return}
                try await userRef.document(currentUser.userName).setData(currentUserData)
            }
        }
        else {
            Task {
                // Remove current user from target user's followers list
                var targetUserInfo = try await getUserInfo(user: targetUser)
                targetUserInfo.followers.removeAll(where: { $0 == currentUser.userName})
                guard let targetUserData = targetUserInfo.asDictionary() else {return}
                try await userRef.document(targetUser.userName).setData(targetUserData)
                
                // Remove target user from current user's following list
                var currentUserInfo = try await getUserInfo(user: currentUser)
                currentUserInfo.following.removeAll(where: { $0 == targetUser.userName})
                guard let currentUserData = currentUserInfo.asDictionary() else {return}
                try await userRef.document(currentUser.userName).setData(currentUserData)
            }
        }
    }
}
