//
//  NotificationsViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit

///Notification Screen
final class NotificationsViewController: UIViewController {
    
//MARK: - Properties
    // emptyImageView and headerView need to start off as optional so that I can initialize it with a
    // frame later to properly call the views with all their subviews
    private var emptyImageView: NotificationEmptyStateView?
    private var headerView: NotificationsHeaderView?
    private var models = [NotificationsVCViewModel]()
    
//MARK: - SubViews
    private let notificationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Notifications_All_TableViewCell.self, forCellReuseIdentifier: Notifications_All_TableViewCell.identifier)
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addTweetButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemCyan
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = K.addButtonSize/2
        button.layer.masksToBounds = true
        return button
    }()
    
    

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isTranslucent = false
        configureNavbar()
        configureHeaderView()
        configureTableView()
        fetchData()
        configureEmptyStateView()
        configureAddTweetButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
   
//MARK: - Configure
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: nil)
    }

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
    
    private func configureAddTweetButton() {
        view.addSubview(addTweetButton)
        let addTweetButtonConstraints = [
            addTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            addTweetButton.heightAnchor.constraint(equalToConstant: K.addButtonSize),
            addTweetButton.widthAnchor.constraint(equalToConstant: K.addButtonSize)
        ]
        NSLayoutConstraint.activate(addTweetButtonConstraints)
        addTweetButton.addTarget(self, action: #selector(didTapAddTweetButton), for: .touchUpInside)
    }
    

//MARK: - Networking
    private func fetchData() {
        //API Call
        //Mock Data
        models = NotificationsVCViewModel.mockNotifications()
        notificationsTableView.reloadData()
    }

//MARK: - Actions
    @objc private func didTapAddTweetButton() {
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
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
        
    }
    
    func tappedMentionsButton() {
        // Show only mention notifications
        
    }
    
    
}
