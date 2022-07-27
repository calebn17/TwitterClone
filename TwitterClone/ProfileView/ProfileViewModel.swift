//
//  ProfileViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/25/22.
//

import Foundation

struct ProfileViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    
    static func getProfileHeaderViewModel(user: User) async throws -> ProfileHeaderViewModel? {
        let userHeaderInfo = try await DatabaseManager.shared.getUserInfo(user: user)
        let profilePictureURL = try await StorageManager.shared.downloadProfilePicture(user: user)
        
        if let profilePictureURL = profilePictureURL {
            let result = ProfileHeaderViewModel(
                userName: userHeaderInfo.userName,
                userHandle: userHeaderInfo.userHandle,
                bio: userHeaderInfo.bio,
                followers: userHeaderInfo.followers,
                following: userHeaderInfo.following,
                profileImage: profilePictureURL
            )
            return result
        } else {
            let result = ProfileHeaderViewModel(
                userName: userHeaderInfo.userName,
                userHandle: userHeaderInfo.userHandle,
                bio: userHeaderInfo.bio,
                followers: userHeaderInfo.followers,
                following: userHeaderInfo.following,
                profileImage: nil
            )
            return result
        }
    }
    
    static func setProfileBio(bio: String, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.insertUserBio(bio: bio) { success in
            if !success {
                print("Error when inserting profile info into database")
                completion(false)
            }
            completion(true)
        }
    }
   
    static func getProfileTweets(user: User) async throws -> [TweetViewModel] {
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
    
    static func updateRelationship(targetUser: User, didFollow: Bool, completion: @escaping (Bool) -> Void) {
        DatabaseManager.shared.updateRelationship(targetUser: targetUser, didFollow: didFollow) { success in
            if !success {
                print("Something went wrong when updating relationship")
                completion(false)
            }
            completion(true)
        }
    }
    
    static func uploadProfilePicture(user: User, data: Data?, completion: @escaping (Bool) -> Void) {
        StorageManager.shared.uploadProfilePicture(user: user, data: data) { success in
            completion(success == true)
        }
    }
}
