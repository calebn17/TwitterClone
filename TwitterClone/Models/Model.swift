//
//  SettingsSections.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import Foundation

struct SettingsModel {
    let title: String
    let icon: String?
}

struct SettingsAndPrivacyModel {
    let title: String
    let icon: String
    let description: String
}

struct NotificationsModel {
    let userName: String
    let action: NotificationActions
    let tweetBody: String
    let profilePicture: String?
    let date: Date?
}

struct User: Codable {
    var id: Int?
    var userName: String
    var userHandle: String
    var userEmail: String
}


struct HomeTweetViewCellViewModel {
    let id: String?
    let userName: String
    let userAvatar: URL?
    let tweetBody: String
    let url_link: URL?
}

struct TweetModel: Codable {
    let tweetId: String
    var username: String?
    var userHandle: String?
    var userEmail: String?
    let userAvatar: String?
    let text: String?
    var likers: [User]
    var isRetweetedByUser: Bool?
    var likes: Int?
    var retweets: Int?
    var comments: [CommentsModel]?
    let dateCreated: Date?
}

struct CommentsModel: Codable {
    let commentId: String?
    let username: String?
    let userHandle: String?
    let userAvatar: String?
    let text: String?
    var isLikedByUser: Bool?
    var isRetweetedByUser: Bool?
    var likes: Int?
    var retweets: Int?
    let dateCreated: Date?
}

