//
//  HomeCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController()
        vc.coordinator = self
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }

//MARK: - HomeVC Routes
    func tappedLeftNavBarButton(user: User) {
        let vc = ProfileViewController(with: user)
        vc.title = "Profile"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentLoginVC(sender: HomeViewController) {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        sender.present(vc, animated: false)
    }
    
    func tappedOnAddTweetButton(sender: HomeViewController) {
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = sender
        sender.present(vc, animated: true, completion: nil)
    }
    
//MARK: - TweetCell Routes
    func tappedOnTweetCell(tweet: TweetViewModel) {
        let vc = SelectedTweetViewController(with: tweet)
        vc.title = "Tweet"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedOnProfilePicture(user: User) {
        let vc = ProfileViewController(with: user)
        vc.title = user.userName
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedOnCommentButton(sender: HomeViewController, tweet: TweetViewModel) {
        let vc = AddCommentViewController(with: tweet)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = sender
        sender.present(vc, animated: true, completion: nil)
    }
    
    func tappedOnRetweetbutton(
        sender: HomeViewController,
        tweet: TweetViewModel,
        retweeted: Bool,
        completion: @escaping (Bool) -> Void)
    {
        if retweeted {
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
                HomeVCViewModel.retweeted(tweet: tweet) { success in
                    completion(success == true)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak sender] _ in
                //need to pass in the text body here
                let vc = AddTweetViewController()
                vc.modalPresentationStyle = .fullScreen
                sender?.present(vc, animated: true, completion: nil)
                completion(false)
            }))
            sender.present(actionSheet, animated: true, completion: nil)
        }
        else {
            HomeVCViewModel.unRetweeted(tweet: tweet) { success in
                completion(success == true)
            }
        }
    }
    
    func tappedOnShareButton(sender: HomeViewController, tweet: TweetViewModel) {
        let firstAction = "Checkout \(tweet.username)'s tweet!"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        sender.present(shareAction, animated: true, completion: nil)
    }
    
    
    
    
    
    
}
