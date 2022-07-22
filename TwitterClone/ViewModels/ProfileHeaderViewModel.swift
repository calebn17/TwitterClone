//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import Foundation

struct ProfileHeaderViewModel: Codable {
    let userName: String
    let userHandle: String
    let bio: String?
    let followerCount: Int?
    let followingCount: Int?
    let profileImage: URL?
    
    static func getProfileHeaderViewModel(user: User) async throws -> ProfileHeaderViewModel? {
        guard let result = try await DatabaseManager.shared.getUserInfo(user: user) else {
            return nil
        }
        let viewModel = ProfileHeaderViewModel(
            userName: result.userName,
            userHandle: result.userHandle,
            bio: result.bio ?? "",
            followerCount: result.followerCount,
            followingCount: result.followingCount,
            profileImage: result.profileImage
        )
        return viewModel
    }
    
    static func setProfileBio(bio: String) {
        DatabaseManager.shared.insertUserBio(bio: bio) { success in
            if !success {
                print("Error when inserting profile info into database")
            }
        }
    }
    
    
    
    static func getProfileTweets(user: User) async throws -> [TweetModel] {
        let allTweets = try await DatabaseManager.shared.getTweets()
        print(user.userName)
        let filteredTweets = allTweets.filter { tweet in
            if tweet.likers.contains(user.userName) ||
                tweet.retweeters.contains(user.userName) ||
                tweet.comments.contains(where: { $0.username == user.userName }) ||
                tweet.username == user.userName {
                return true
            } else {
                return false
            }
        }
        return filteredTweets
    }
}
