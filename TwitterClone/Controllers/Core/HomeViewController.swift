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

//MARK: - Setup
    static let shared = HomeViewController()
    public var tweetResponses: [TweetModel] = []
    private var user = UserModel(id: nil, userName: "", userHandle: "", userEmail: "")
    
    //Temporary collection to hold added comments
    //Just to demonstrate functionality
    private var addedComments = [CommentsModel]()
    
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

//MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //let tabBarHeight = tabBarController?.tabBar.height
        self.tabBarController?.tabBar.isTranslucent = false
        view.backgroundColor = .systemBackground
        configureNavbar()
        configureHomeFeedTableView()
        fetchData()
        configureAddTweetButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 30)
    }
    
    //Whenever this screen comes into view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        fetchUserData()
    }

//MARK: - Configure Methods
    
    private func configureNavbar() {
        var image = UIImage(named: "twitterLogo")
        image?.accessibilityFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //forces xcode to use the original image (logo comes out as different color if this isnt done)
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                            style: .done,
                                                            target: self,
                                                            action: nil)
        navigationItem.titleView = twitterIcon
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = ""
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
    
//MARK: - Fetch Methods
    
    private func fetchData() {
        APICaller.shared.getSearch(with: "bitcoin") { [weak self] results in
            switch results {
            case .success(let tweets):
                DispatchQueue.main.async {
                    self?.tweetResponses = tweets
                    self?.homeFeedTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchUserData() {
        //fetching the user's email
        guard let user = Auth.auth().currentUser
        else {
            print("User is not signed in")
            return
        }
        self.user.userEmail = user.email ?? "no email"
        
        //fetching the user's username
        let email = user.email ?? "No email"
        DatabaseManager.shared.getUsername(email: email, completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let db_username):
                    self?.user.userName = db_username
                    UserDefaults.standard.set(db_username, forKey: "username")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
        //fetching the user's handle
        DatabaseManager.shared.getUserHandle(email: email, completion: {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let handle):
                    self?.user.userHandle = handle
                    UserDefaults.standard.set(handle, forKey: "userHandle")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        })
    }
    
//MARK: - Action Methods
    
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
    
//    //Hides the navBar as the user scrolls down (navigates down the page)
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //let defaultOffset = view.safeAreaInsets.top
//        let defaultOffset: CGFloat = -100
//        let offset = scrollView.contentOffset.y + defaultOffset
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
}

//MARK: - TweetTableViewCellDelegate Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapCommentButton() {
        let vc = AddCommentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(with model: TweetModel, completion: @escaping (Bool) -> Void) {
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
            completion(true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
            //need to pass in the text body here
            let vc = AddTweetViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func didTapLikeButton(liked: Bool, model: TweetModel) {
        if liked {
//            //like the tweet and add 1 to the count
//            let likedTweets = tweetResponses.filter {$0.tweetId == model.tweetId}
//            guard var likedTweet = likedTweets.first else {return}
//            var likesCount = likedTweet.likes ?? 0
//            likesCount += 1
//            likedTweet.likes = likesCount
//            homeFeedTableView.reloadData()
        }
        else {
            //unlike tweet and subtract 1 from the count
        }
    }
    
    func didTapShareButton() {
        let firstAction = "This Tweet"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        present(shareAction, animated: true, completion: nil)
    }
    
    func didTapLikeButtonInComment(liked: Bool, model: CommentsModel) {
        //For SelectedTweetVC
        //have this stubbed out to just simply conform to the delegate
        //not looking to do anything here
    }
    
    func didTapRetweetInComment(with model: CommentsModel, completion: @escaping (Bool) -> Void) {
        //For SelectedTweetVC
        //have this stubbed out to just simply conform to the delegate
        //not looking to do anything here
    }
}

//MARK: - AddTweetViewControllerDelegate Methods
extension HomeViewController: AddTweetViewControllerDelegate {
    
    func didTapTweetPublishButton(tweetBody: String) {
        //setting addedTweet as a var so I can update the username values
        let addedTweet = TweetModel(
            tweetId: UUID().uuidString,
            username: user.userName,
            userHandle: user.userHandle,
            userEmail: user.userEmail,
            userAvatar: nil,
            text: tweetBody,
            isLikedByUser: false,
            isRetweetedByUser: false,
            likes: 0,
            retweets: 0,
            comments: nil,
            dateCreated: Date()
        )
        
        tweetResponses.insert(addedTweet, at: 0)
        DatabaseManager.shared.insertTweet(with: addedTweet) { success in
            if success {
                print("Tweet saved")
            }
            else {
                print("Tweet was not saved: error")
            }
        }
        homeFeedTableView.reloadData()
    }
}

//MARK: - AddCommentViewControllerDelegate Methods
extension HomeViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String) {
        let commentID = Int.random(in: 0...100)
        let addedComment = CommentsModel(commentId: commentID, username: user.userName, userHandle: user.userHandle, userAvatar: nil, text: tweetBody, isLikedByUser: false, isRetweetedByUser: false, likes: 0, retweets: 0, dateCreated: Date())
        //Will insert this comment under the Parent tweet in the DB, and then will refetch tweet info from DB
        
        //for now, will add the new comment to this collection to demonstrate functionality
        addedComments.append(addedComment)
        homeFeedTableView.reloadData()
    }
    
    
}
