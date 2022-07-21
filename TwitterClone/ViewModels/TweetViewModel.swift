//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/20/22.
//

import Foundation

struct TweetModel: Codable {
    let tweetId: String
    var username: String?
    var userHandle: String?
    var userEmail: String?
    let userAvatar: String?
    let text: String?
    var likers: [String]
    var retweeters: [String]
    var comments: [TweetModel]
    let dateCreatedString: String?
}
