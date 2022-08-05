//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseStorage

public class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    private init() {}
    
//MARK: - Profile Picture

    func uploadProfilePicture(user: User, data: Data?) async throws {
        guard let data = data else {return}
        storage.child("\(user.userName)/profile_picture.png").putData(data)    }
    
    func downloadProfilePicture(user: User) async throws -> URL? {
        let url: URL? = try await storage.child("\(user.userName)/profile_picture.png").downloadURL()
        return url
    }
}
