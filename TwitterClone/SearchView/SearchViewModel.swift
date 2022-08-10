//
//  SearchViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/25/22.
//

import Foundation

struct SearchViewModel {
    
    var currentUser: User { return DatabaseManager.shared.currentUser }
    @MainActor var searchData = Observable<[TweetModel]>([])
    
    @MainActor func fetchSearchData(query: String) async throws {
        let response = try await APICaller.shared.getSearch(with: query)
        let results = response.compactMap({
            TweetModel(
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
        searchData.value = results
    }
}
