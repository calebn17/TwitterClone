//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct TweetModel: Codable {
    let tweetId: String
    var username: String
    var userHandle: String
    var userEmail: String
    var userAvatar: URL?
    let text: String?
    var likers: [String]
    var retweeters: [String]
    var comments: [TweetModel]
    let dateCreatedString: String?
}

struct TweetViewModel {
   
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    static func fetchProfilePictureURL(tweet: TweetModel) async throws -> URL? {
        let user = User(
            id: nil,
            userName: tweet.username,
            userHandle: tweet.userHandle,
            userEmail: tweet.userEmail
        )
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        return url
    }
}

