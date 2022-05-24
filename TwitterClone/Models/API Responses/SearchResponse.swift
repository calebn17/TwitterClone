//
//  VolumeStreamsResponse.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

struct SearchResponse: Codable {
    let data: [Tweet]
}

struct Tweet: Codable {
    let username: String?
    let id: String?
    let text: String?
    let likes: Int?
}


