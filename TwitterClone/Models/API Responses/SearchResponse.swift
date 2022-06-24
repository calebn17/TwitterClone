//
//  VolumeStreamsResponse.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

struct SearchResponse: Codable {
    let data: [TweetModel]
}

struct TweetResponse: Codable {
    let id: String?
    let text: String?
}


//let id: String?
//let userName: String?
//let userHandle: String?
//let userAvatar: String?
//let tweetBody: String?
//let isLikedByUser: Bool?
//let isRetweetedByUser: Bool?
//let likes: Int?
//let retweets: Int?
//let comments: [CommentsModel]?
//let dateCreated: Date?
