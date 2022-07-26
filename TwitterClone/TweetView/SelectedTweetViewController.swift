//
//  SelectedTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

class SelectedTweetViewController: UIViewController {
    
//MARK: - Properties
    private var tweet: TweetViewModel
    private var comments: [TweetViewModel]
    private var headerView: SelectedTweetHeaderTableViewCell?
    
//MARK: - SubViews
    
    private let selectedTweetTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.register(SelectedTweetHeaderTableViewCell.self, forCellReuseIdentifier: SelectedTweetHeaderTableViewCell.identifier)
        return tableView
    }()

//MARK: - Init
    init(with tweet: TweetViewModel){
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
        title = "Tweet"
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
    
    func didTapHeaderCommentButton() {
        
    }
    
    func didTapHeaderLikeButton(liked: Bool, model: TweetViewModel) {
        
    }
    
    func didTapHeaderShareButton() {
        
    }
}

extension SelectedTweetViewController: TweetTableViewCellDelegate {
    
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
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(false)
            }))
            actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: { _ in
                DatabaseManager.shared.updateRetweetStatus(type: .retweeted, tweet: model) { success in
                    if !success {
                        completion(false)
                        print("Something went wrong when retweeting")
                    }
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
            DatabaseManager.shared.updateRetweetStatus(type: .notRetweeted, tweet: model) { success in
                if !success {
                    completion(false)
                    print("Something went wrong when unretweeting")
                }
                completion(true)
            }
        }
    }
    
    func didTapLikeButton(liked: Bool, model: TweetViewModel) {
        // insert User into the likers collection in the TweetModel and update DB
        DatabaseManager.shared.updateLikeStatus(type: liked ? .liked : .unliked, tweet: model) { success in
            if !success {
                print("Error occured when updating like status")
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

//MARK: - AddCommentViewControllerDelegate Methods
extension SelectedTweetViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String, owner: TweetViewModel) {
        //
    }
}
