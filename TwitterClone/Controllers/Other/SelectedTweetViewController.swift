//
//  SelectedTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

class SelectedTweetViewController: UIViewController {
    
//MARK: - Properties
    private var tweet: TweetModel?
    private var comments: [CommentsModel]?
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
        return comments?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTweetHeaderTableViewCell.identifier, for: indexPath) as? SelectedTweetHeaderTableViewCell,
                  let tweet = self.tweet
            else {return UITableViewCell()}
            cell.configure(with: tweet)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell
            else {return UITableViewCell()}
            cell.delegate = self
            cell.configureComment(
                with: CommentsModel(
                    commentId: nil,
                    username: nil,
                    userHandle: nil,
                    userAvatar: nil,
                    text: nil,
                    likers: [],
                    retweeters: [],
                    dateCreated: nil
                )
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - CellDelegate Methods
extension SelectedTweetViewController: TweetTableViewCellDelegate, SelectedTweetHeaderTableViewCellDelegate {
    func didTapCommentButton() {
        let vc = AddCommentViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    func didTapRetweet(with model: TweetModel) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
            //need to pass in the comment's text body here
            let vc = AddTweetViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func didTapLikeButton(liked: Bool, model: TweetModel) {
       //
    }
    
    func didTapShareButton() {
        let firstAction = "This Tweet"
        let shareAction = UIActivityViewController(activityItems: [firstAction], applicationActivities: nil)
        shareAction.isModalInPresentation = true
        present(shareAction, animated: true, completion: nil)
    }
    
    func didTapLikeButtonInComment(liked: Bool, model: CommentsModel) {
        //update the the likes and liked properties in the DB
    }
    
    func didTapRetweetInComment(with model: CommentsModel) {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Retweet", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Quote", style: .default, handler: {[weak self] _ in
            //need to pass in the comment's text body here
            let vc = AddTweetViewController()
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - AddCommentViewControllerDelegate Methods
extension SelectedTweetViewController: AddCommentViewControllerDelegate {
    func didTapReplyButton(tweetBody: String) {
        //
    }
}
