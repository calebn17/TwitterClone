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
    
    private let storage = Storage.storage().reference()
    
//    func uploadTweet(with tweet: TweetModel, completion: @escaping (URL?) -> Void) {
//        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
//        
//        let ref = storage.child("\(username)/tweet/\(tweet)")
//        ref.putData(<#T##uploadData: Data##Data#>)
//                
//               
//        
//    }
    
    
}
