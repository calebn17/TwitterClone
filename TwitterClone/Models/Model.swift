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

public enum NotificationActions {
    case liked
    case reply
    case retweet
    case followed
}

struct NotificationsModel {
    let userName: String
    let action: NotificationActions
    let tweetBody: String
    let profilePicture: String?
    let date: Date?
}

struct UserModel {
    var id: Int?
    var userName: String
    var userEmail: String
}
