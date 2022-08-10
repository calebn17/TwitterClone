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
    @MainActor var profilePictureURL = Observable<URL?>(nil)
    
    @MainActor func fetchProfilePictureURL(tweet: TweetModel) async throws {
        let user = User(
            id: nil,
            userName: tweet.username,
            userHandle: tweet.userHandle,
            userEmail: tweet.userEmail
        )
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        profilePictureURL.value = url
    }
    
    static func updateLikeStatus(liked: Bool, tweet: TweetModel) async throws {
        try await DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: tweet)
    }
}

