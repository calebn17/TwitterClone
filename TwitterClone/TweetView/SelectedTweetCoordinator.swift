//
//  SelectedTweetCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 8/6/22.
//

import Foundation
import UIKit

final class SelectedTweetCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var tweet: TweetModel
    
    init(navigationController: UINavigationController, tweet: TweetModel) {
        self.navigationController = navigationController
        self.tweet = tweet
    }
    
    func start() {
        let vc = SelectedTweetViewController(with: tweet)
        vc.coordinator = self
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
