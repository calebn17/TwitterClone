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
    //let author_id: String?
    //let created_at: String?
    let id: String?
    let text: String?
}


