//
//  HomeVCViewModel.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 6/25/22.
//

import Foundation

class HomeVCViewModel {
    
    var tweets = [TweetModel]()
    
    init() {}
    
    private func fetchData() {
        
        var apiTweets = [TweetModel]()
        var dbTweets = [TweetModel]()
        
        let group = DispatchGroup()
        
        group.enter()
        APICaller.shared.getSearch(with: "bitcoin") {results in
            switch results {
            case .success(let tweets):
                DispatchQueue.main.async {
                    apiTweets = tweets
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        group.enter()
        DatabaseManager.shared.getTweets { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let tweets):
                    dbTweets = tweets
                case .failure(let error):
                    print(error.localizedDescription)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {[weak self] in
            DispatchQueue.main.async {
                print("done fetching tweets from API and DB")
                self?.tweets = dbTweets + apiTweets
                
            }
        }
    }
    
    
}
