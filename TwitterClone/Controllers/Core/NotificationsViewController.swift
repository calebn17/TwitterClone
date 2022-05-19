//
//  NotificationsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

///Notification Screen
final class NotificationsViewController: UIViewController {
    
//MARK: - Setup
    
    private let notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = false
        return tableView
    }()
    
    private var emptyImageView: NotificationEmptyStateView?
    
    
    private var headerView: NotificationsHeaderView?
    private var models = [NotificationsModel]()

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        configureHeaderView()
        configureEmptyStateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notificationsTableView.frame = view.bounds
    }
   
//MARK: - Configure Methods
    
    private func configureTableView() {
        view.addSubview(notificationsTableView)
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
    }
    
    private func configureEmptyStateView() {
        emptyImageView = NotificationEmptyStateView(frame: view.bounds)
        guard let emptyImageView = emptyImageView else {return}
        view.addSubview(emptyImageView)
        
        if models.count == 0 {
            notificationsTableView.isHidden = true
            emptyImageView.isHidden = false
        }
    }
    
    private func configureHeaderView() {
        headerView = NotificationsHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 45))
        notificationsTableView.tableHeaderView = headerView
        headerView?.delegate = self
    }

}

//MARK: - TableView Methods

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}

//MARK: - NotifcationsHeaderViewDelegate Methods
extension NotificationsViewController: NotificationsHeaderViewDelegate {
    func tappedAllButton() {
        // Show all notifications
    }
    
    func tappedMentionsButton() {
        // Show only mention notifications
    }
    
    
}
