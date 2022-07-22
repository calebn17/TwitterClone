//
//  SettingsSections.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/9/22.
//

import Foundation

struct User: Codable, Equatable {
    let id: Int?
    let userName: String
    let userHandle: String
    let userEmail: String
}

struct UserInfo: Codable {
    let id: Int?
    let userName: String
    let userHandle: String
    let userEmail: String
    let bio: String?
    let followerCount: Int?
    let followingCount: Int?
    let profileImage: URL?
}




