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
        tableView.register(Notifications_All_TableViewCell.self, forCellReuseIdentifier: Notifications_All_TableViewCell.identifier)
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //emptyImageView and headerView need to start off as optional so that I can initialize it with a frame later to properly call the views with all their subviews
    private var emptyImageView: NotificationEmptyStateView?
    private var headerView: NotificationsHeaderView?
    private var models = [NotificationsModel]()

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHeaderView()
        configureTableView()
        fetchData()
        configureEmptyStateView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
   
//MARK: - Configure Methods

    private func configureHeaderView() {
        //With the way I'm doing things, I need to initialize the headerView with a frame (x,y are not super important because I'm using AutoLayout but I do need to set the width and height)
        //If I don't init it with a frame, it will show as a generic view with none of it's defined subviews
        headerView = NotificationsHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        guard let headerView = headerView else {return}
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 100),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.widthAnchor.constraint(equalToConstant: view.width)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
    }
    
    private func configureTableView() {
        view.addSubview(notificationsTableView)
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        guard let headerView = headerView else {return}
        
        //Seems like in order to keep the tableView from overlapping the tabbar, I need to include a safeAreaInset value to either the top or bottom anchor constraint (in the constant)
        let notificationsTableViewConstraints = [
            notificationsTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            notificationsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notificationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.safeAreaInsets.bottom)
        ]
        NSLayoutConstraint.activate(notificationsTableViewConstraints)
        print("This is the bottom safeAreaInset \(view.safeAreaInsets.bottom)")
        print("This is the top safeAreaInset \(view.safeAreaInsets.top)")
    }
    
    private func configureEmptyStateView() {
        emptyImageView = NotificationEmptyStateView(frame: view.bounds)
        guard let emptyImageView = emptyImageView else {return}
        view.addSubview(emptyImageView)
        
        if models.count == 0 {
            notificationsTableView.isHidden = true
            emptyImageView.isHidden = false
        }
        else {
            notificationsTableView.isHidden = false
            emptyImageView.isHidden = true
        }
    }
    

//MARK: - Action Methods
    
    private func fetchData() {
        //API Call
        
        //Mock Data
        
        for x in 0...30 {
            let action: NotificationActions
            let i = x*Int.random(in: 0...20)
            if i % 2 == 0 {action = .followed}
            else {action = .liked}
            
            models.append(NotificationsModel(userName: "@User \(i)", action: action, tweetBody: "Wow this is really cool!!!", profilePicture: nil, date: nil))
        }
        notificationsTableView.reloadData()
    }
}

//MARK: - TableView Methods

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Notifications_All_TableViewCell.identifier, for: indexPath) as? Notifications_All_TableViewCell
        else {return UITableViewCell()}
        
        let model = models[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - NotifcationsHeaderViewDelegate Methods
extension NotificationsViewController: NotificationsHeaderViewDelegate {
    func tappedAllButton() {
        // Show all notifications
        print("All Notifications")
    }
    
    func tappedMentionsButton() {
        // Show only mention notifications
        print("Mentions Notifications")
    }
    
    
}
