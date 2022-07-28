//
//  HomeCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let vc = HomeViewController()
        vc.coordinator = self
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

//MARK: - HomeVC Routes
    func tappedLeftNavBarButton(user: User) {
        let vc = ProfileViewController(with: user)
        vc.title = "Profile"
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentLoginVC(sender: HomeViewController) {
        let child = LoginCoordinator(navigationController: navigationController, sender: sender)
        childCoordinators.append(child)
        child.start()
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
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedOnProfilePicture(user: User) {
        let child = ProfileCoordinator(navigationController: navigationController, user: user)
        childCoordinators.append(child)
        child.start()
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

extension HomeCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a profile view controller
        if let profileVC = fromViewController as? ProfileViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(profileVC.coordinator)
        }
        else if let loginVC = fromViewController as? LoginViewController {
            childDidFinish(loginVC.coordinator)
        }
    }
}
