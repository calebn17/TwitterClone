//
//  OnboardingViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 8/5/22.
//

import Foundation

struct OnboardingViewModel {
    
    static func registerNewUser(user: User, password: String, data: Data?) async throws {
        try await AuthManager.shared.registerNewUser(newUser: user, password: password)
        try await StorageManager.shared.uploadProfilePicture(user: user, data: data)
    }
    
    static func logIn(email: String, password: String) async throws {
        try await AuthManager.shared.loginUser(email: email.lowercased(), password: password.lowercased())
    }
    
    static func logOut() async throws {
        try await AuthManager.shared.logOut()
    }
}
