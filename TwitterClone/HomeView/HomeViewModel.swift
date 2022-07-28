//
//  HomeVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/25/22.
//

import Foundation
import UIKit

struct HomeViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    static func fetchData() async throws -> [TweetModel] {
        //let responseTweets = try await APICaller.shared.getSearch(with: "news")
        let dbTweets = try await DatabaseManager.shared.getTweets()
        
//        let apiTweets = responseTweets.compactMap({
//            TweetViewModel(
//                tweetId: UUID().uuidString,
//                username: nil,
//                userHandle: nil,
//                userEmail: nil,
//                userAvatar: nil,
//                text: $0.text,
//                likers: [],
//                retweeters: [],
//                comments: [],
//                dateCreatedString: nil
//            )
//        })
        return dbTweets //+ apiTweets
    }
    
    static func fetchProfilePictureURL(user: User) async throws -> URL? {
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        return url
    }
    
    static func publishTweet(user: User, body: String) async throws -> TweetModel {
        let url = try await HomeViewModel.fetchProfilePictureURL(user: user)
        
        //setting addedTweet as a var so I can update the username values
        let addedTweet = TweetModel(
            tweetId: UUID().uuidString,
            username: user.userName,
            userHandle: user.userHandle,
            userEmail: user.userEmail,
            userAvatar: url,
            text: body,
            likers: [],
            retweeters: [],
            comments: [],
            dateCreatedString: String.date(from: Date())
        )
        DatabaseManager.shared.insertTweet(with: addedTweet) { success in
            if success {
                print("Tweet saved")
            }
            else {
                print("Tweet was not saved: error")
            }
        }
        return addedTweet
    }
    
    static func publishComment(owner: TweetModel, body: String, completion: @escaping (Bool) -> Void) {
        
        DatabaseManager.shared.insertComment(tweetId: owner.tweetId, text: body) { success in
            if !success {
                print("Could not insert comment")
            }
            
            DatabaseManager.shared.insertNotifications(
                of: .comment,
                tweet: owner) { successful in
                    if !successful {
                        print("Error occured when inserting notification")
                    }
                    completion(true)
                }
        }
    }
    
    static func tappedLikeButton(liked: Bool, model: TweetModel, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: model) { success in
            if !success {
                print("Error occured when updating like status")
            }
            if liked {
                DatabaseManager.shared.insertNotifications(
                    of: .liked,
                    tweet: model) { successful in
                        if !successful {
                            print("Error occured when inserting notification")
                        }
                        completion(true)
                    }
            }
        }
    }
    
    static func retweeted(tweet: TweetModel, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.updateRetweetStatus(type: .retweeted, tweet: tweet) { success in
            if !success {
                print("Something went wrong when retweeting")
            }
            DatabaseManager.shared.insertNotifications(of: .retweet, tweet: tweet) { success in
                if !success {
                    print("Something went wrong when updating notifications in DB")
                }
            }
            completion(true)
        }
    }
    
    static func unRetweeted(tweet: TweetModel, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.updateRetweetStatus(type: .unRetweeted, tweet: tweet) { success in
            if !success {
                print("Something went wrong when unretweeting")
            }
            completion(true)
        }
    }
}
