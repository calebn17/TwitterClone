//
//  StorageManager.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/23/22.
//

import Foundation
import FirebaseStorage
import Foundation

public class StorageManager {
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
   
//
//    public enum IGStorageManagerError: Error {
//        case failedToDownload
//        case failedToUpload
//    }
//
////MARK: - Public Methods
//
//    public func uploadUserPost(model: UserPost, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void) {
//
//    }
//
//    public func downloadImage(with reference: String, completion: @escaping (Result<URL, IGStorageManagerError>) -> Void ) {
//        bucket.child(reference).downloadURL { url, error in
//            guard let url = url, error != nil else {
//                completion(.failure(.failedToDownload))
//                return
//            }
//            completion(.success(url))
//        }
//    }
   
}
