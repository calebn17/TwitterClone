//
//  HomeVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/25/22.
//

import Foundation

struct HomeVCViewModel {
    
    static func fetchData() async throws -> [TweetModel] {
        let responseTweets = try await APICaller.shared.getSearch(with: "news")
        let dbTweets = try await DatabaseManager.shared.getTweets()
        
        let apiTweets = responseTweets.compactMap({
            TweetModel(
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
}
