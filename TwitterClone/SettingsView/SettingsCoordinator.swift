//
//  SettingsCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit
import SafariServices

class SettingsCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SettingsViewController()
        vc.coordinator = self
        navigationController.delegate = self
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
    
//MARK: - Settings TableView Routes
    func tappedOnProfilePageCell(user: User) {
        let child = ProfileCoordinator(navigationController: navigationController, user: user)
        childCoordinators.append(child)
        child.start()
    }
    
    func tappedOnHelpPageCell(sender: SettingsViewController) {
        guard let url = URL(string: "https://help.twitter.com/en") else {return}
        let vc = SFSafariViewController(url: url)
        sender.present(vc, animated: true, completion: nil)
    }
    
    func tappedOnSettingsAndPrivacyPage() {
        let vc = SettingsAndPrivacyViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    func tappedSignOut(sender: SettingsViewController) {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthManager.shared.logOut {[weak sender] success in
                DispatchQueue.main.async { [weak self] in
                    if success {
                        guard let strongSender = sender,
                              let navC = self?.navigationController else {return}
                        let child = LoginCoordinator(
                            navigationController: navC,
                            sender: strongSender
                        )
                        self?.childCoordinators.append(child)
                        child.start()
                    }
                    else {
                        //error when logging out
                        fatalError("Could not log out user")
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sender.present(alert, animated: true, completion: nil)
    }
    
}

extension SettingsCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        // We’re still here – it means we’re popping the view controller, so we can check whether it’s a buy view controller
        if let profileVC = fromViewController as? ProfileViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(profileVC.coordinator)
        }
        else if let loginVC = fromViewController as? LoginViewController {
            childDidFinish(loginVC.coordinator)
        }
    }
}
