//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct TweetViewModel: Codable {
    let tweetId: String
    var username: String?
    var userHandle: String?
    var userEmail: String?
    let userAvatar: URL?
    let text: String?
    var likers: [String]
    var retweeters: [String]
    var comments: [TweetViewModel]
    let dateCreatedString: String?
}

