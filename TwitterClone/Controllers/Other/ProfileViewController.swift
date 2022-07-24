//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit

class ProfileViewController: UIViewController {

//MARK: - Properties
    private let user: User
    var isCurrentUser: Bool {
        print(DatabaseManager.shared.currentUser == user)
        return DatabaseManager.shared.currentUser == user
    }
    private var profileInfo: ProfileHeaderViewModel?
    private var tweets = [TweetModel]()
    
//MARK: - SubViews
    private var headerView: ProfileHeaderView?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
//MARK: - Init
    init(with user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
        configureTableView()
        configureNavBar()
        configureHeaderView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

//MARK: - Configure
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureHeaderView() {
        headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 270))
        tableView.tableHeaderView = headerView
        headerView?.delegate = self
    }
    
    private func configureNavBar() {
        if isCurrentUser {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(didTapEditButton))
        }
    }
    
//MARK: - Networking
    private func fetchData() {
        Task {
            do {
                // Fetching user profile info
                guard let profileInfo = try await ProfileHeaderViewModel.getProfileHeaderViewModel(user: self.user) else {return}
                // Fetching tweets that will populate the tableView
                tweets = try await ProfileHeaderViewModel.getProfileTweets(user: self.user)
                print(self.user.userName)
                headerView?.configure(with: profileInfo)
                tableView.reloadData()
            }
            catch {
                print("Error when fetching user info in profile vc")
            }
        }
    }
    
    
//MARK: - Actions 
    
    @objc private func didTapEditButton() {
        let vc = EditProfileViewController()
        vc.delegate = self
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

//MARK: - TableView Methods
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.identifier,
            for: indexPath
        ) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        let tweet = tweets[indexPath.row]
        cell.configure(with: tweet)
        return cell
                
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tweet = tweets[indexPath.row]
        let vc = SelectedTweetViewController(with: tweet)
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - HeaderView Methods
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didTapOnFollowButton(didFollow: Bool) {
        ProfileHeaderViewModel.updateRelationship(targetUser: user, didFollow: didFollow) {[weak self] success in
            DispatchQueue.main.async {
                if !success {
                    print("Something went wrong when updating relationship")
                }
                self?.fetchData()
            }
        }
    }
}

//MARK: - EditProfileVC Methods
extension ProfileViewController: EditProfileViewControllerDelegate {
    func tappedSaveButton(bio: String) {
        ProfileHeaderViewModel.setProfileBio(bio: bio) {[weak self] success in
            DispatchQueue.main.async {
                if !success {
                    print("Something went wrong when updating bio")
                }
                self?.fetchData()
            }
        }
    }
}
