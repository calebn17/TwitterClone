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
    @MainActor var tweetModels = Observable<[TweetModel]>([])

    @MainActor func fetchData() async throws {
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
        tweetModels.value =  dbTweets //+ apiTweets
    }
    
    @MainActor func publishTweet(user: User, body: String) async throws {
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
            dateCreatedString: String(describing: Date().timeIntervalSince1970)
        )
        try await DatabaseManager.shared.insertTweet(with: addedTweet)
        tweetModels.value?.insert(addedTweet, at: 0)
    }
    
    static func fetchProfilePictureURL(user: User) async throws -> URL? {
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        return url
    }
    
    static func publishComment(owner: TweetModel, body: String) async throws {
        try await DatabaseManager.shared.insertComment(tweetId: owner.tweetId, text: body)
        try await DatabaseManager.shared.insertNotifications(of: .comment, tweet: owner)
    }
    
    static func tappedLikeButton(liked: Bool, model: TweetModel) async throws {
        try await DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: model)
        try await DatabaseManager.shared.insertNotifications(of: .liked, tweet: model)
    }
    
    static func retweeted(tweet: TweetModel) async throws {
        try await DatabaseManager.shared.updateRetweetStatus(type: .retweeted, tweet: tweet)
        try await DatabaseManager.shared.insertNotifications(of: .retweet, tweet: tweet)
    }
    
    static func unRetweeted(tweet: TweetModel) async throws {
        try await DatabaseManager.shared.updateRetweetStatus(type: .unRetweeted, tweet: tweet)
    }
}
