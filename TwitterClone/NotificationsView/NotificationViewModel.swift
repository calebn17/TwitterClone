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

struct NotificationsViewModel: Codable {
    let senderUserName: String
    let action: NotificationActions.RawValue
    let model: TweetViewModel
    let dateString: String
    
    static func fetchData() async throws -> [NotificationsViewModel] {
        var notifications = try await DatabaseManager.shared.getNotifications()
        
        notifications.sort(by: {
            return $0.dateString > $1.dateString
        })
        
        return notifications
    }
    
    static func getTweet(viewModel: TweetViewModel) async throws -> TweetViewModel? {
        let tweet = try await DatabaseManager.shared.getTweet(with: viewModel.tweetId)
        return tweet
    }
}
