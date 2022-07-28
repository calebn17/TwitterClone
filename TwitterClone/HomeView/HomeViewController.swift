//
//  HomeViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/5/22.
//

import UIKit
import FirebaseAuth

///Home Screen
final class HomeViewController: UIViewController {

//MARK: - Properties
    weak var coordinator: HomeCoordinator?
    
    private var currentUser: User {
        return HomeViewModel().currentUser
    }
    public var tweetResponses: [TweetModel] = []
    
//MARK: - SubViews
    private let profilePictureImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person")
        imageView.layer.cornerRadius = K.userImageSize/2
        return imageView
    }()
    
    private let twitterIcon: CustomImageView = {
        let icon = CustomImageView(frame: .zero)
        icon.image = UIImage(named: "twitterLogo")
        icon.contentMode = .scaleAspectFit
        return icon
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
    
    public let homeFeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        configureNavbar()
        //configureProfileImage()
        configureHomeFeedTableView()
        configureAddTweetButton()
        updateUI()
        configurePullToRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("login"), object: nil)
    }
    
//MARK: - Networking
    @objc private func updateUI() {
        Task {
            tweetResponses = try await HomeViewModel.fetchData()
            homeFeedTableView.reloadData()
        }
    }

//MARK: - Actions
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        updateUI()
        sender.endRefreshing()
    }
    
    private func handleNotAuthenticated() {
        if Auth.auth().currentUser == nil {
            coordinator?.presentLoginVC(sender: self)
        }
    }
    
    @objc private func didTapAddTweetButton() {
        coordinator?.tappedOnAddTweetButton(sender: self)
    }
    
    @objc private func didTapLeftNavBarButton() {
        coordinator?.tappedLeftNavBarButton(user: currentUser)
    }
}

//MARK: - TableView Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.identifier,
            for: indexPath
        ) as? TweetTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: tweetResponses[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        coordinator?.tappedOnTweetCell(tweet: tweetResponses[indexPath.row])
    }
}

//MARK: - TweetCell Action Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapProfilePicture(user: User) {
        coordinator?.tappedOnProfilePicture(user: user)
    }
    
    func didTapCommentButton(owner: TweetModel) {
        coordinator?.tappedOnCommentButton(sender: self, tweet: owner)
    }
    
    func didTapRetweet(retweeted: Bool, model: TweetModel, completion: @escaping (Bool) -> Void) {
        coordinator?.tappedOnRetweetbutton(
            sender: self,
            tweet: model,
            retweeted: retweeted,
            completion: { success in
            completion(success == true)
        })
    }
    
    func didTapLikeButton(liked: Bool, model: TweetModel) {
        HomeViewModel.tappedLikeButton(liked: liked, model: model) { success in
            if !success {
                print("Something went wrong went liking")
            }
        }
    }
    
    func didTapShareButton(tweet: TweetModel) {
        coordinator?.tappedOnShareButton(sender: self, tweet: tweet)
    }
}

//MARK: - AddTweetViewVC Methods
extension HomeViewController: AddTweetViewControllerDelegate, SearchViewControllerDelegate {
    
    func didTapPublishTweet(tweetBody: String, publishedFromSearchVC sender: SearchViewController) {
        didTapTweetPublishButton(tweetBody: tweetBody)
    }
    
    func didTapTweetPublishButton(tweetBody: String) {
        Task {
            let addedTweet = try await HomeViewModel.publishTweet(user: currentUser, body: tweetBody)
            tweetResponses.insert(addedTweet, at: 0)
            homeFeedTableView.reloadData()
        }
    }
}

//MARK: - AddCommentVC Methods
extension HomeViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String, owner: TweetModel) {
        HomeViewModel.publishComment(owner: owner, body: tweetBody) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.updateUI()
                }
            }
        }
    }
}

//MARK: - Configure
extension HomeViewController {
    
//    private func configureProfileImage() {
//        view.addSubview(profilePictureImageView)
//
//        let profilePictureImageViewConstraints = [
//            profilePictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
//            profilePictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
//            profilePictureImageView.heightAnchor.constraint(equalToConstant: K.userImageSize*0.8),
//            profilePictureImageView.widthAnchor.constraint(equalToConstant: K.userImageSize*0.8),
//        ]
//        NSLayoutConstraint.activate(profilePictureImageViewConstraints)
//
//        Task {
//            let url = try await HomeVCViewModel.fetchProfilePictureURL(user: currentUser)
//            profilePictureImageView.sd_setImage(with: url)
//            navigationItem.leftBarButtonItem = UIBarButtonItem(image: profilePictureImageView.image, style: .done, target: self, action: nil)
//        }
//    }
    
    private func configureNavbar() {
        var image = UIImage(named: "twitterLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.titleView = twitterIcon
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .done,
            target: self,
            action: #selector(didTapLeftNavBarButton)
        )
    }
    
    private func configureHomeFeedTableView() {
        view.addSubview(homeFeedTableView)
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
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
    
    private func configurePullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        homeFeedTableView.refreshControl = control
    }
}
