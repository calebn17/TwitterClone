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
    private var viewModel = HomeViewModel()
    private var currentUser: User { return HomeViewModel().currentUser }

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
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .label
        spinner.startAnimating()
        return spinner
    }()

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        configureNavbar()
        configureHomeFeedTableView()
        configureAddTweetButton()
        handleLoadingStateUI()
        updateUI()
        fetchData()
        configurePullToRefresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 40)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: Notification.Name("login"), object: nil)
    }
    
//MARK: - Configure
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configurePullToRefresh() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
    }
    
    private func handleLoadingStateUI() {
        view.addSubview(spinner)
        if viewModel.tweetModels.value == nil {
            tableView.isHidden = true
        } else {
            spinner.stopAnimating()
            spinner.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    private func updateUI() {
        viewModel.tweetModels.bind {[weak self] _ in
            self?.handleLoadingStateUI()
            self?.tableView.reloadData()
        }
    }
    
//MARK: - Networking
    @objc private func fetchData() {
        Task {
            try await viewModel.fetchData()
        }
    }

//MARK: - Actions
    @objc private func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        fetchData()
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
        return viewModel.tweetModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.identifier,
            for: indexPath
        ) as? TweetTableViewCell,
              let model = viewModel.tweetModels.value?[indexPath.row]
        else { return UITableViewCell() }
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let model = viewModel.tweetModels.value?[indexPath.row] else {return}
        coordinator?.tappedOnTweetCell(tweet: model)
    }
}

//MARK: - TweetCell Action Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapProfilePicture(_ cell: TweetTableViewCell, user: User) {
        coordinator?.tappedOnProfilePicture(user: user)
    }
    
    func didTapCommentButton(_ cell: TweetTableViewCell, owner: TweetModel) {
        coordinator?.tappedOnCommentButton(sender: self, tweet: owner)
    }
    
    func didTapRetweet(_ cell: TweetTableViewCell, retweeted: Bool, model: TweetModel, completion: @escaping (Bool) -> Void) {
        coordinator?.tappedOnRetweetbutton(
            sender: self,
            tweet: model,
            retweeted: retweeted,
            completion: { success in
            completion(success == true)
        })
    }
    
    func didTapLikeButton(_ cell: TweetTableViewCell, liked: Bool, model: TweetModel) {
        Task {
            try await HomeViewModel.tappedLikeButton(liked: liked, model: model)
        }
    }
    
    func didTapShareButton(_ cell: TweetTableViewCell, tweet: TweetModel) {
        coordinator?.tappedOnShareButton(sender: self, tweet: tweet)
    }
}

//MARK: - AddTweetViewVC Methods
extension HomeViewController: AddTweetViewControllerDelegate {
    func didTapTweetPublishButton(_ cell: AddTweetViewController, tweetBody: String) {
        Task {
            try await viewModel.publishTweet(user: currentUser, body: tweetBody)
        }
    }
}

//MARK: - AddCommentVC Methods
extension HomeViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(_ cell: AddCommentViewController, tweetBody: String, owner: TweetModel) {
        Task {
            try await HomeViewModel.publishComment(owner: owner, body: tweetBody)
            fetchData()
        }
    }
}

//MARK: - Constraints
extension HomeViewController {
    
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
}
