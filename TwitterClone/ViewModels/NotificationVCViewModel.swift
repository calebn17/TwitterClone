//
//  NotificationVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/27/22.
//

import Foundation

public enum NotificationActions: Int {
    case liked = 1
    case comment = 2
    case retweet = 3
    case followed = 4
}

struct NotificationsVCViewModel: Codable {
    let senderUserName: String
    let action: NotificationActions.RawValue
    let model: TweetModel
    let dateString: String
    
    static func fetchData() async throws -> [NotificationsVCViewModel] {
        let notifications = try await DatabaseManager.shared.getNotifications()
        return notifications
    }
//    static func mockNotifications() -> [NotificationsVCViewModel] {
//        var notifications = [NotificationsVCViewModel]()
//
//        for x in 0...30 {
//            let action: NotificationActions
//            let i = x * Int.random(in: 0...20)
//
//            if i % 2 == 0 {
//                action = .followed
//            }
//            else {
//                action = .liked
//            }
//            notifications.append(NotificationsVCViewModel(userName: "@User \(i)", action: action, tweetBody: "Wow this is really cool!!!", profilePicture: nil, date: nil))
//        }
//        return notifications
//    }
}
