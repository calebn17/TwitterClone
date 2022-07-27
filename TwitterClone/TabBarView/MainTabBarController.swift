//
//  TabBarCoordinatorController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/27/22.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {
    
    let home = HomeCoordinator(navigationController: UINavigationController())
    let search = SearchCoordinator(navigationController: UINavigationController())
    let notifications = NotificationsCoordinator(navigationController: UINavigationController())
    let settings = SettingsCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        home.start()
        search.start()
        notifications.start()
        settings.start()
        
        let nav1 = home.navigationController
        let nav2 = search.navigationController
        let nav3 = notifications.navigationController
        let nav4 = settings.navigationController
        
        nav1.navigationItem.largeTitleDisplayMode = .never
        nav2.navigationItem.largeTitleDisplayMode = .never
        nav3.navigationItem.largeTitleDisplayMode = .never
        nav4.navigationItem.largeTitleDisplayMode = .never
        
        nav1.navigationBar.tintColor = .white
        nav2.navigationBar.tintColor = .white
        nav3.navigationBar.tintColor = .white
        nav4.navigationBar.tintColor = .white
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        nav4.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell.fill"), tag: 1)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape.fill"), tag: 1)
        
        setViewControllers([nav1,nav2,nav3,nav4], animated: false)
        
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().tintColor = .white
    }
}
