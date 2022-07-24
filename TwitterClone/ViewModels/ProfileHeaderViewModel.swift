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
    var bio: String
    var followers: [String]
    var following: [String]
    var profileImage: URL?
    
    static func getProfileHeaderViewModel(user: User) async throws -> ProfileHeaderViewModel? {
        guard let result = try await DatabaseManager.shared.getUserHeaderInfo(user: user) else {
            return nil
        }
        return result
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
    
    static func updateRelationship(targetUser: User, didFollow: Bool) {
        DatabaseManager.shared.updateRelationship(targetUser: targetUser, didFollow: didFollow) { success in
            if !success {
                print("Something went wrong when updating relationship")
            }
        }
    }
}
