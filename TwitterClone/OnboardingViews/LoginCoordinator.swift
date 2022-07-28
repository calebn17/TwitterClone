//
//  OnboardingCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/28/22.
//

import Foundation
import UIKit

class LoginCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var sender: AnyObject
    
    
    init(navigationController: UINavigationController, sender: AnyObject) {
        self.navigationController = navigationController
        self.sender = sender
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func start() {
        navigationController.delegate = self
        let vc = LoginViewController()
        vc.coordinator = self
        vc.modalPresentationStyle = .fullScreen
        sender.present(vc, animated: true) {[weak sender] in
            sender?.navigationController?.popToRootViewController(animated: false)
            sender?.tabBarController?.selectedIndex = 0
        }
    }
    
    func tappedOnRegisterButton(sender: LoginViewController) {
        let child = RegisterCoordinator(navigationController: navigationController, sender: sender)
        childCoordinators.append(child)
        child.start()
    }
    
    func successfulLogin(sender: LoginViewController) {
        NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
        sender.dismiss(animated: true, completion: nil)
    }
    
    func presentLoginErrorAlert(sender: LoginViewController) {
        let alert = UIAlertController(title: "Log In Error", message: "We were unable to log you in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        sender.present(alert, animated: true)
    }
}

extension LoginCoordinator: UINavigationControllerDelegate {
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
        if let loginVC = fromViewController as? LoginViewController {
            // We're popping a buy view controller; end its coordinator
            childDidFinish(loginVC.coordinator)
        }
    }
}
