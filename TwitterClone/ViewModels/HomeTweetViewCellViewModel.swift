//
//  HomeTweetViewCellViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

///Tweet's metadata
struct HomeTweetViewCellViewModel {
    let id: String?
    let userName: String
    let userAvatar: URL?
    let tweetBody: String
    let url_link: URL?
}
