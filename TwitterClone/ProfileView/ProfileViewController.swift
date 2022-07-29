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
    var isCurrentUser: Bool {
        return ProfileViewModel().currentUser == user
    }
    private var profileInfo: ProfileHeaderViewModel?
    private var tweets = [TweetModel]()
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
        configureTableView()
        configureNavBar()
        configureHeaderView()
        view.addSubview(spinner)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
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
    
//MARK: - Networking
    private func updateUI() {
        Task {
            do {
                // Fetching user profile info
                guard let profileInfo = try await ProfileViewModel.getProfileHeaderViewModel(user: self.user) else {return}
                // Fetching tweets that will populate the tableView
                tweets = try await ProfileViewModel.getProfileTweets(user: self.user)
                spinner.stopAnimating()
                spinner.isHidden = true
                headerView?.configure(with: profileInfo)
                configureUI()
            }
            catch {
                print("Error when fetching user info in profile vc")
            }
        }
    }
    
    private func configureUI() {
        if profileInfo != nil {
            tableView.isHidden = true
            headerView?.isHidden = true
        } else {
            tableView.isHidden = false
            headerView?.isHidden = false
        }
        tableView.reloadData()
    }
    
    
//MARK: - Actions 
    
    @objc private func didTapEditButton() {
        coordinator?.tappedEditButton(sender: self)
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
        coordinator?.tappedOnTweetCell(tweet: tweet)
    }
}

//MARK: - HeaderView Methods
extension ProfileViewController: ProfileHeaderViewDelegate {
    func didTapOnProfilePicture() {
        guard isCurrentUser else {return}
        coordinator?.tappedOnProfilePicture(sender: self)
    }
    
    func didTapOnFollowButton(didFollow: Bool) {
        ProfileViewModel.updateRelationship(targetUser: user, didFollow: didFollow) {[weak self] success in
            DispatchQueue.main.async {
                if !success {
                    print("Something went wrong when updating relationship")
                }
                self?.updateUI()
            }
        }
    }
}

//MARK: - EditProfileVC Methods
extension ProfileViewController: EditProfileViewControllerDelegate {
    func tappedSaveButton(bio: String) {
        ProfileViewModel.setProfileBio(bio: bio) {[weak self] success in
            DispatchQueue.main.async {
                if !success {
                    print("Something went wrong when updating bio")
                }
                self?.updateUI()
            }
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
        ProfileViewModel.uploadProfilePicture(user: user, data: image.pngData()) {[weak self] success in
            if success {
                self?.tweets = []
                self?.updateUI()
            }
        }
    }
}
