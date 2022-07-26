//
//  HomeVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/25/22.
//

import Foundation
import UIKit

struct HomeVCViewModel {
    
    static func fetchData() async throws -> [TweetViewModel] {
        let responseTweets = try await APICaller.shared.getSearch(with: "news")
        let dbTweets = try await DatabaseManager.shared.getTweets()
        
        let apiTweets = responseTweets.compactMap({
            TweetViewModel(
                tweetId: UUID().uuidString,
                username: nil,
                userHandle: nil,
                userEmail: nil,
                userAvatar: nil,
                text: $0.text,
                likers: [],
                retweeters: [],
                comments: [],
                dateCreatedString: nil
            )
        })
        return dbTweets + apiTweets
    }
    
    static func fetchProfilePictureURL(user: User) async throws -> URL? {
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        return url
    }
    
    static func publishTweet(user: User, body: String) async throws -> TweetViewModel {
        let url = try await HomeVCViewModel.fetchProfilePictureURL(user: user)
        
        //setting addedTweet as a var so I can update the username values
        let addedTweet = TweetViewModel(
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
    
    static func publishComment(owner: TweetViewModel, body: String, completion: @escaping (Bool) -> Void) {
        
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
    
    static func tappedLikeButton(liked: Bool, model: TweetViewModel, completion: @escaping (Bool) -> Void) {
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
    
    static func retweeted(tweet: TweetViewModel, completion: @escaping (Bool) -> Void) {
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
    
    static func notRetweeted(tweet: TweetViewModel, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.updateRetweetStatus(type: .notRetweeted, tweet: tweet) { success in
            if !success {
                print("Something went wrong when unretweeting")
            }
            completion(true)
        }
    }
}
