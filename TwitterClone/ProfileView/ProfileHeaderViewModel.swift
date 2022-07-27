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
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
}

