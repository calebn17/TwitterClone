//
//  SelectedTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

class SelectedTweetViewController: UIViewController {
    
    private let selectedTweetTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.register(SelectedTweetHeaderTableViewCell.self, forCellReuseIdentifier: SelectedTweetHeaderTableViewCell.identifier)
        return tableView
    }()
    
    private var tweet: TweetModel?
    private var comments: [CommentsModel]?
    private var headerView: SelectedTweetHeaderTableViewCell?
    
    init(with tweet: TweetModel){
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

    private func configureTableView() {
        view.addSubview(selectedTweetTableView)
        selectedTweetTableView.delegate = self
        selectedTweetTableView.dataSource = self
    }
}

extension SelectedTweetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTweetHeaderTableViewCell.identifier, for: indexPath) as? SelectedTweetHeaderTableViewCell,
                  let tweet = self.tweet
            else {return UITableViewCell()}
            cell.configure(with: tweet)
            cell.selectionStyle = .none
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
            else {return UITableViewCell()}
            cell.delegate = self
            cell.configureComment(with: CommentsModel(commentId: nil, username: nil, userHandle: nil, userAvatar: nil, text: nil, isLikedByUser: nil, isRetweetedByUser: nil, likes: nil, retweets: nil, dateCreated: nil))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SelectedTweetViewController: TweetTableViewCellDelegate {
    
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
}

//MARK: - AddCommentViewControllerDelegate Methods
extension SelectedTweetViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String) {
        //
    }
    
    
}
