//
//  VolumeStreamsResponse.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

struct SearchResponse: Codable {
    let data: [TweetResponse]
}

struct TweetResponse: Codable {
    let id: String?
    let text: String?
}


