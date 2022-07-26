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
    static let shared = HomeViewController()
    
    private var currentUser: User {
        return DatabaseManager.shared.currentUser
    }
    private var username: String {
        return DatabaseManager.shared.currentUser.userName
    }
    private var userhandle: String {
        return DatabaseManager.shared.currentUser.userHandle
    }
    private var email: String {
        return DatabaseManager.shared.currentUser.userEmail
    }
    public var tweetResponses: [TweetViewModel] = []
    
//MARK: - SubViews
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = K.userImageSize/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let twitterIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "twitterLogo")
        icon.clipsToBounds = true
        icon.contentMode = .scaleAspectFit
        return icon
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
    
    public let homeFeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //let tabBarHeight = tabBarController?.tabBar.height
        self.tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        configureNavbar()
        //configureProfileImage()
        configureHomeFeedTableView()
        configureAddTweetButton()
        fetchData()
        configurePullToRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 30)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Name("login"), object: nil)
    }
    
//MARK: - Networking
    @objc private func fetchData() {
        Task {
            tweetResponses = try await HomeVCViewModel.fetchData()
            homeFeedTableView.reloadData()
        }
    }

//MARK: - Actions
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        fetchData()
        sender.endRefreshing()
    }
    
    private func handleNotAuthenticated() {
        //check Auth status
        if Auth.auth().currentUser == nil {
            //Show Login
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    @objc private func didTapAddTweetButton() {
        //present the addTweetViewController
        let vc = AddTweetViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapLeftNavBarButton() {
        let vc = ProfileViewController(with: currentUser)
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableView Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
        else {return UITableViewCell()}
                
        cell.delegate = self
        cell.configure(with: tweetResponses[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //push a new VC and pass the tweet that was selected and it's comments
        let vc = SelectedTweetViewController(with: tweetResponses[indexPath.row])
        vc.title = "Tweet"
        //dont make the root controller the "vc". it will inherit the nav bar from the parent
        navigationController?.pushViewController(vc, animated: true)
        //show(vc, sender: self)
    }
}

//MARK: - TweetCell Action Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapProfilePicture(user: User) {
        let vc = ProfileViewController(with: user)
        vc.title = user.userName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapCommentButton(owner: TweetViewModel) {
        let vc = AddCommentViewController(with: owner)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(retweeted: Bool, model: TweetViewModel, completion: @escaping (Bool) -> Void) {
        
        if retweeted {
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
                HomeVCViewModel.retweeted(tweet: model) { success in
                    completion(success == true)
                }
            }))
            actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
                //need to pass in the text body here
                let vc = AddTweetViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
                completion(false)
            }))
            present(actionSheet, animated: true, completion: nil)
        }
        else {
            HomeVCViewModel.notRetweeted(tweet: model) { success in
                completion(success == true)
            }
        }
    }
    
    /// User tapped the like button on the tweet
    /// - Parameters:
    ///   - liked: user tapped on the button to like (was in the unlike state before being tapped)
    ///   - model: TweetModel object
    func didTapLikeButton(liked: Bool, model: TweetViewModel) {
        HomeVCViewModel.tappedLikeButton(liked: liked, model: model) { success in
            if !success {
                return
            }
        }
    }
    
    func didTapShareButton() {
        let firstAction = "This Tweet"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        present(shareAction, animated: true, completion: nil)
    }
}

//MARK: - AddTweetViewVC Methods
extension HomeViewController: AddTweetViewControllerDelegate, SearchViewControllerDelegate {
    
    func didTapPublishTweet(tweetBody: String, publishedFromSearchVC sender: SearchViewController) {
        didTapTweetPublishButton(tweetBody: tweetBody)
    }
    
    func didTapTweetPublishButton(tweetBody: String) {
        Task {
            let addedTweet = try await HomeVCViewModel.publishTweet(user: currentUser, body: tweetBody)
            tweetResponses.insert(addedTweet, at: 0)
            homeFeedTableView.reloadData()
        }
    }
}

//MARK: - AddCommentVC Methods
extension HomeViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String, owner: TweetViewModel) {
        HomeVCViewModel.publishComment(owner: owner, body: tweetBody) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.fetchData()
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
