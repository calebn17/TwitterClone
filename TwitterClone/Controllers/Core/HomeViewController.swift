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
    public var tweetResponses: [TweetModel] = []
    
    //Temporary collection to hold added comments
    //Just to demonstrate functionality
    private var addedComments = [TweetModel]()
    
//MARK: - SubViews
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
        configureHomeFeedTableView()
        configureAddTweetButton()
        fetchData()
        
        let searchVC = SearchViewController()
        searchVC.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTableView.frame = CGRect(x: 0, y: 50, width: view.width, height: view.height - 30)
    }
    
    //Whenever this screen comes into view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }

//MARK: - Configure
    
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
    
//MARK: - Networking
    private func fetchData() {
        Task {
            do {
                let responseTweets = try await APICaller.shared.getSearch(with: "bitcoin")
                let dbTweets = try await DatabaseManager.shared.getTweets()
                
                let apiTweets = responseTweets.compactMap({
                    TweetModel(
                        tweetId: UUID().uuidString,
                        username: nil,
                        userHandle: nil,
                        userEmail: nil,
                        userAvatar: nil,
                        text: $0.text,
                        likers: [],
                        retweeters: [],
                        comments: [],
                        dateCreated: nil
                    )
                })
                
                tweetResponses = dbTweets + apiTweets
                homeFeedTableView.reloadData()
            }
            catch {
                print("Request failed with error")
            }
        }
    }
    
    private func updateTweetCollection(apiTweets: [TweetModel], dbTweets: [TweetModel]) {
        print("done fetching tweets from API and DB")
        self.tweetResponses = dbTweets + apiTweets
        self.homeFeedTableView.reloadData()
    }
    
//MARK: - Actions
    
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
}

//MARK: - Tweet Methods
extension HomeViewController: TweetTableViewCellDelegate {
    
    func didTapCommentButton(owner: TweetModel) {
        let vc = AddCommentViewController(with: owner)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(retweeted: Bool, model: TweetModel, completion: @escaping (Bool) -> Void) {
        
        if retweeted {
            let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
                // add user to retweeter collection in TweetModel
                DatabaseManager.shared.updateRetweetStatus(type: .retweeted, tweet: model) { success in
                    if !success {
                        print("Something went wrong when retweeting")
                    }
                    completion(true)
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
            DatabaseManager.shared.updateRetweetStatus(type: .notRetweeted, tweet: model) { success in
                if !success {
                    print("Something went wrong when unretweeting")
                }
            }
        }
    }
    
    
    /// User tapped the like button on the tweet
    /// - Parameters:
    ///   - liked: user tapped on the button to like (was in the unlike state before being tapped)
    ///   - model: TweetModel object
    func didTapLikeButton(liked: Bool, model: TweetModel) {
        // insert User into the likers collection in the TweetModel and update DB
        DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: model) { success in
            if !success {
                print("Error occured when updating like status")
            }
            if liked {
                DatabaseManager.shared.insertNotifications(
                    of: .liked,
                    from: DatabaseManager.shared.currentUser.userName,
                    tweet: model) { successful in
                        if !successful {
                            print("Error occured when inserting notification")
                        }
                    }
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
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let userHandle = UserDefaults.standard.string(forKey: "userHandle"),
              let email = UserDefaults.standard.string(forKey: "email")
        else {return}
        
        //setting addedTweet as a var so I can update the username values
        let addedTweet = TweetModel(
            tweetId: UUID().uuidString,
            username: username,
            userHandle: userHandle,
            userEmail: email,
            userAvatar: nil,
            text: tweetBody,
            likers: [],
            retweeters: [],
            comments: [],
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

//MARK: - AddCommentVC Methods
extension HomeViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String, owner: TweetModel) {
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let userHandle = UserDefaults.standard.string(forKey: "userHandle")
        else {return}
        
        let commentID = UUID().uuidString
        let addedComment = TweetModel(
            tweetId: commentID,
            username: username,
            userHandle: userHandle,
            userEmail: nil,
            userAvatar: nil,
            text: tweetBody,
            likers: [],
            retweeters: [],
            comments: [],
            dateCreated: Date()
        )
        //for now, will add the new comment to this collection to demonstrate functionality
        addedComments.append(addedComment)
        
        //Will insert this comment under the Parent tweet in the DB, and then will refetch tweet info from DB
        DatabaseManager.shared.insertComment(tweetId: owner.tweetId, text: tweetBody) { [weak self] success in
            if !success {
                print("Could not insert comment")
            }
            self?.homeFeedTableView.reloadData()
            
            DatabaseManager.shared.insertNotifications(
                of: .comment,
                from: DatabaseManager.shared.currentUser.userName,
                tweet: owner) { successful in
                    if !successful {
                        print("Error occured when inserting notification")
                    }
                }
        }
    }
}
