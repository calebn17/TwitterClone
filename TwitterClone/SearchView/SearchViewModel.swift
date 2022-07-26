//
//  SearchViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/25/22.
//

import Foundation

struct SearchViewModel {
    
    static func fetchSearchData(query: String) async throws -> [TweetViewModel] {
        let response = try await APICaller.shared.getSearch(with: query)
        let results = response.compactMap({
            TweetViewModel(
                tweetId: UUID().uuidString,
                username: "",
                userHandle: "",
                userEmail: "",
                userAvatar: nil,
                text: $0.text,
                likers: [],
                retweeters: [],
                comments: [],
                dateCreatedString: nil
            )
        })
        return results
    }
}
