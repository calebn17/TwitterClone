//
//  VolumeStreamsResponse.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

struct VolumeStreamsResponse: Codable {
    let data: [Tweet]
}

struct Tweet: Codable {
    let author_id: Int?
    let created_at: String?
    let id: Int?
    let text: String?
}


