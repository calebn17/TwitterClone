//
//  SettingsSections.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import Foundation



struct SettingsAndPrivacyModel {
    let title: String
    let icon: String
    let description: String
}

struct User: Codable {
    var id: Int?
    var userName: String
    var userHandle: String
    var userEmail: String
}

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


