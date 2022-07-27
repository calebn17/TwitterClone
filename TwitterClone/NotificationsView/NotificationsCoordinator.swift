//
//  NotificationsCoordinator.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

class NotificationsCoordinator: Coordinator {
    var childrenCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = NotificationsViewController()
        vc.navigationItem.backButtonDisplayMode = .minimal
        navigationController.pushViewController(vc, animated: false)
    }
}
