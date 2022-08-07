//
//  SelectedTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

final class SelectedTweetViewController: UIViewController {
    
//MARK: - Properties
    private var tweet: TweetModel
    private var comments: [TweetModel]
    private var headerView: SelectedTweetHeaderTableViewCell?
    
//MARK: - SubViews
    
    private let selectedTweetTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.register(SelectedTweetHeaderTableViewCell.self, forCellReuseIdentifier: SelectedTweetHeaderTableViewCell.identifier)
        return tableView
    }()

//MARK: - Init
    init(with tweet: TweetModel){
        self.tweet = tweet
        self.comments = tweet.comments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectedTweetTableView.frame = view.bounds
    }
    
//MARK: - Configure
    private func configureTableView() {
        view.addSubview(selectedTweetTableView)
        selectedTweetTableView.delegate = self
        selectedTweetTableView.dataSource = self
    }
}

//MARK: - TableView Methods
extension SelectedTweetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Adding 1 here to account for the headerView
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTweetHeaderTableViewCell.identifier, for: indexPath) as? SelectedTweetHeaderTableViewCell
            else {return UITableViewCell()}
            cell.configure(with: self.tweet)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
            else {return UITableViewCell()}
            //cell.delegate = self
            let model = comments[indexPath.row - 1]
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - CellDelegate Methods
extension SelectedTweetViewController: SelectedTweetHeaderTableViewCellDelegate {
    
    func didTapHeaderCommentButton(_ cell: SelectedTweetHeaderTableViewCell) {
        
    }
    
    func didTapHeaderLikeButton(_ cell: SelectedTweetHeaderTableViewCell, liked: Bool, model: TweetModel) {
        
    }
    
    func didTapHeaderShareButton(_ cell: SelectedTweetHeaderTableViewCell) {
        
    }
}

extension SelectedTweetViewController: TweetTableViewCellDelegate {
    func didTapProfilePicture(_ cell: TweetTableViewCell, user: User) {
        let vc = ProfileViewController(with: user)
        vc.title = user.userName
        navigationController?.pushViewController(vc, animated: true)
    }
   
    func didTapCommentButton(_ cell: TweetTableViewCell, owner: TweetModel) {
        let vc = AddCommentViewController(with: owner)
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(
        _ cell: TweetTableViewCell,
        retweeted: Bool,
        model: TweetModel,
        completion: @escaping (Bool) -> Void) {
            
            if retweeted {
                let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    completion(false)
                }))
                actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
                    Task {
                        try await DatabaseManager.shared.updateRetweetStatus(type: .retweeted, tweet: model)
                        completion(true)
                    }
                }))
                actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
                    //need to pass in the comment's text body here
                    let vc = AddTweetViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true, completion: nil)
                    completion(false)
                }))
                present(actionSheet, animated: true, completion: nil)
            }
            else {
                Task {
                    try await DatabaseManager.shared.updateRetweetStatus(type: .unRetweeted, tweet: model)
                    completion(true)
                }
            }
        }
    
    func didTapLikeButton(_ cell: TweetTableViewCell, liked: Bool, model: TweetModel) {
        // insert User into the likers collection in the TweetModel and update DB
        Task {
            try await DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: model)
        }
    }
    
    func didTapShareButton(_ cell: TweetTableViewCell, tweet: TweetModel) {
        let firstAction = "This Tweet"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        present(shareAction, animated: true, completion: nil)
    }
}

//MARK: - AddCommentViewControllerDelegate Methods
extension SelectedTweetViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(_ sender: AddCommentViewController, tweetBody: String, owner: TweetModel) {
        
    }
}
