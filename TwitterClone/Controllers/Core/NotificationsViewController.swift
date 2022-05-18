//
//  NotificationsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit
///Notification Screen
final class NotificationsViewController: UIViewController {
    
    private let notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let emptyImageView: UIView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        return imageView
    }()
    
    private var headerView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(notificationsTableView)
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notificationsTableView.frame = view.bounds
    }


}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
