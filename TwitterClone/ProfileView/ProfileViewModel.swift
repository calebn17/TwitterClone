//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/25/22.
//

import Foundation

struct ProfileHeaderViewModel {
    let userName: String
    let userHandle: String
    var bio: String
    var followers: [String]
    var following: [String]
    var profileImage: URL?
}


struct ProfileViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    @MainActor var headerViewModel = Observable<ProfileHeaderViewModel>(nil)
    @MainActor var tweets = Observable<[TweetModel]>([])
    
    @MainActor func getProfileHeaderViewModel(user: User) async throws {
        let userHeaderInfo = try await DatabaseManager.shared.getUserInfo(user: user)
        let profilePictureURL = try await StorageManager.shared.downloadProfilePicture(user: user)
        
        let result = ProfileHeaderViewModel(
            userName: userHeaderInfo.userName,
            userHandle: userHeaderInfo.userHandle,
            bio: userHeaderInfo.bio,
            followers: userHeaderInfo.followers,
            following: userHeaderInfo.following,
            profileImage: profilePictureURL
        )
        headerViewModel.value = result
    }
    
   
    @MainActor func getProfileTweets(user: User) async throws {
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
        tweets.value = filteredTweets
    }
    
    static func setProfileBio(bio: String) async throws {
        try await DatabaseManager.shared.insertUserBio(bio: bio)
    }
    
    static func updateRelationship(targetUser: User, didFollow: Bool) async throws{
        try await DatabaseManager.shared.updateRelationship(targetUser: targetUser, didFollow: didFollow)
    }
    
    static func uploadProfilePicture(user: User, data: Data?) async throws {
        try await StorageManager.shared.uploadProfilePicture(user: user, data: data)
    }
}
