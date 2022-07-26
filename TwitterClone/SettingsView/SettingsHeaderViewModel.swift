//
//  SettingsHeaderViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/25/22.
//

import Foundation

struct SettingsHeaderViewModel {
    let profilePictureURL: URL?
    let username: String
    let userhandle: String
    let followers: [String]
    let following: [String]
    
    static func fetchData(user: User) async throws -> SettingsHeaderViewModel {
        let userInfo = try await DatabaseManager.shared.getUserInfo(user: user)
        let url = try await StorageManager.shared.downloadProfilePicture(user: user)
        let viewModel = SettingsHeaderViewModel(
            profilePictureURL: url,
            username: user.userName,
            userhandle: user.userHandle,
            followers: userInfo.followers,
            following: userInfo.following
        )
        return viewModel
    }
}
