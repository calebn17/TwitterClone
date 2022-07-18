//
//  NotificationVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/27/22.
//

import Foundation

public enum NotificationActions {
    case liked
    case reply
    case retweet
    case followed
}

struct NotificationsVCViewModel{
    let userName: String
    let action: NotificationActions
    let tweetBody: String
    let profilePicture: String?
    let date: Date?
    
    static func mockNotifications() -> [NotificationsVCViewModel] {
        var notifications = [NotificationsVCViewModel]()
        
        for x in 0...30 {
            let action: NotificationActions
            let i = x * Int.random(in: 0...20)
            
            if i % 2 == 0 {
                action = .followed
            }
            else {
                action = .liked
            }
            notifications.append(NotificationsVCViewModel(userName: "@User \(i)", action: action, tweetBody: "Wow this is really cool!!!", profilePicture: nil, date: nil))
        }
        return notifications
    }
}
