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
    weak var coordinator: NotificationsCoordinator?
    private var viewModel = NotificationsViewModel()
    private var emptyImageView: NotificationEmptyStateView?
    private var headerView: NotificationsHeaderView?
    
//MARK: - SubViews
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Notifications_All_TableViewCell.self, forCellReuseIdentifier: Notifications_All_TableViewCell.identifier)
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let addTweetButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemCyan
        button.tintColor = .white
        button.layer.cornerRadius = K.addButtonSize/2
        return button
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        spinner.tintColor = .label
        return spinner
    }()
 
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isTranslucent = false
        view.addSubview(spinner)
        configureNavbar()
        configureHeaderView()
        configureTableView()
        configureConstraints()
        updateUI()
        fetchData()
        configureEmptyStateView()
        emptyStateCheck()
        configurePullToRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchData),
            name: Notification.Name("login"),
            object: nil
        )
    }
    
    private func updateUI() {
        viewModel.notificationModels.bind { _ in
            DispatchQueue.main.async { [weak self] in
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.emptyStateCheck()
                self?.tableView.reloadData()
            }
        }
    }

//MARK: - Networking
    @objc private func fetchData() {
        //DB Call
        Task {
            do {
                try await viewModel.fetchData()
            }
            catch {
                print("error when fetching notifications")
            }
        }
    }

//MARK: - Actions
    
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        fetchData()
        sender.endRefreshing()
    }
}
//MARK: - TableView Methods
extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return viewModel.notificationModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Notifications_All_TableViewCell.identifier,
            for: indexPath
        ) as? Notifications_All_TableViewCell,
              let model = viewModel.notificationModels.value?[indexPath.row]
        else {return UITableViewCell()}
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = viewModel.notificationModels.value?[indexPath.row].model else {return}
        
        Task {
            guard let tweet = try await NotificationsViewModel.getTweet(model: model) else {
                print("Error when getting tweet and pushing selectedTweetVC")
                return
            }
            coordinator?.tappedOnNotification(tweet: tweet)
        }
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

//MARK: - Configure/Constraints
extension NotificationsViewController {
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: nil
        )
    }

    private func configureHeaderView() {
        headerView = NotificationsHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        guard let headerView = headerView else {return}
        view.addSubview(headerView)
        headerView.delegate = self
        headerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureEmptyStateView() {
        emptyImageView = NotificationEmptyStateView(frame: view.bounds)
        guard let emptyImageView = emptyImageView else {return}
        view.addSubview(emptyImageView)
    }
    
    private func emptyStateCheck() {
        guard let emptyImageView = emptyImageView else {return}
        
        if viewModel.notificationModels.value?.count == 0 {
            tableView.isHidden = true
            emptyImageView.isHidden = false
        }
        else {
            tableView.isHidden = false
            emptyImageView.isHidden = true
        }
    }
    
    private func configurePullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    private func configureConstraints() {
        guard let headerView = headerView else {return}
        //Seems like in order to keep the tableView from overlapping the tabbar, I need to include a safeAreaInset value to either the top or bottom anchor constraint (in the constant)
        let notificationsTableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.safeAreaInsets.bottom)
        ]
        let headerViewConstraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 100),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.widthAnchor.constraint(equalToConstant: view.width)
        ]
        NSLayoutConstraint.activate(headerViewConstraints)
        NSLayoutConstraint.activate(notificationsTableViewConstraints)
    }
}

