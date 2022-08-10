//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit

final class ProfileViewController: UIViewController {

//MARK: - Properties
    private let user: User
    private var viewModel = ProfileViewModel()
    var isCurrentUser: Bool {
        return viewModel.currentUser == user
    }
    weak var coordinator: ProfileCoordinator?
    
//MARK: - SubViews
    private var headerView: ProfileHeaderView?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
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
        updateUI()
        fetchData()
        configureTableView()
        configureNavBar()
        configureHeaderView()
        view.addSubview(spinner)
        handleEmptyStateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
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
    
    private func handleEmptyStateUI() {
        if viewModel.headerViewModel.value == nil {
            tableView.isHidden = true
            headerView?.isHidden = true
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
            tableView.isHidden = false
            headerView?.isHidden = false
        }
        tableView.reloadData()
    }
    
    func updateUI() {
        viewModel.headerViewModel.bind {[weak self] headerViewModel in
            guard let headerViewModel = headerViewModel else {return}
            self?.headerView?.configure(with: headerViewModel)
        }
        
        viewModel.tweets.bind { [weak self] _ in
            self?.handleEmptyStateUI()
        }
    }
    
//MARK: - Networking
    private func fetchData() {
        Task {
            do {
                // Fetching user profile info
                try await viewModel.getProfileHeaderViewModel(user: self.user)
                // Fetching tweets that will populate the tableView
                try await viewModel.getProfileTweets(user: self.user)
            }
            catch {
                print("Error when fetching user info in profile vc")
            }
        }
    }

//MARK: - Actions 
    
    @objc private func didTapEditButton() {
        coordinator?.tappedEditButton(sender: self)
    }
}

//MARK: - TableView Methods
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.identifier,
            for: indexPath
        ) as? TweetTableViewCell,
              let tweet = viewModel.tweets.value?[indexPath.row]
        else {return UITableViewCell()}

        cell.configure(with: tweet)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tweet = viewModel.tweets.value?[indexPath.row] else {return}
        coordinator?.tappedOnTweetCell(tweet: tweet)
    }
}

//MARK: - HeaderView Methods
extension ProfileViewController: ProfileHeaderViewDelegate {
    func profileHeaderViewDidTapOnProfilePicture() {
        guard isCurrentUser else {return}
        coordinator?.tappedOnProfilePicture(sender: self)
    }
    
    func profileHeaderViewDidTapOnFollowButton(didFollow: Bool) {
        Task {
            try await ProfileViewModel.updateRelationship(targetUser: user, didFollow: didFollow)
            fetchData()
        }
    }
}

//MARK: - EditProfileVC Methods
extension ProfileViewController: EditProfileViewControllerDelegate {
    func editProfileViewControllerTappedSaveButton(bio: String) {
        Task {
            try await ProfileViewModel.setProfileBio(bio: bio)
            fetchData()
        }
    }
}

//MARK: - Image Picker Methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        Task {
            try await ProfileViewModel.uploadProfilePicture(user: user, data: image.pngData())
            self.fetchData()
        }
    }
}
