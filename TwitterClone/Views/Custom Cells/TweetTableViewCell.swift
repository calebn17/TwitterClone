//
//  HomeTweetTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import UIKit

//MARK: - Protocol
protocol TweetTableViewCellDelegate: AnyObject {
    func didTapCommentButton()
    func didTapRetweet(with model: TweetModel, completion: @escaping (Bool) -> Void)
    func didTapLikeButton(liked: Bool, model: TweetModel)
    func didTapShareButton()
    func didTapRetweetInComment(with model: CommentsModel, completion: @escaping (Bool) -> Void)
    func didTapLikeButtonInComment(liked: Bool, model: CommentsModel)
}
///Individual Tweet Cell
class TweetTableViewCell: UITableViewCell {

//MARK: - Properties
    static let identifier = "HomeTweetTableViewCell"
    public weak var delegate: TweetTableViewCellDelegate?
    private var tweetModel: TweetModel?
    private var commentModel: CommentsModel?
    private var likesCount = 0
    private var commentsCount = 0
    private var retweetsCount = 0
    
    
//MARK: - SubViews
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.textAlignment = .left
        label.text = "Username"
        return label
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        imageView.tintColor = .label
        return imageView
    }()
    
    private let twitterTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    private let userHandleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.text = "@userHandle"
        label.clipsToBounds = true
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bubble.left", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.2.squarepath", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retweetsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "14"
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
//MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.backgroundColor = .systemBackground
        addSubViews()
        configureConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Configure
    
    private func addSubViews() {
        //add contentView here so that autolayout constraints work and automatically resize
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userImage)
        contentView.addSubview(twitterTextLabel)
        contentView.addSubview(userHandleLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(retweetsCountLabel)
    }
    
    private func configureConstraints() {
        
        let userImageConstraints = [
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let twitterTextLabelConstraints = [
            twitterTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            twitterTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            twitterTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        let userHandleLabelConstraints = [
            userHandleLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 5),
            userHandleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let commentButtonConstraints = [
            commentButton.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            commentButton.topAnchor.constraint(equalTo: twitterTextLabel.bottomAnchor, constant: 10),
            commentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            commentButton.widthAnchor.constraint(equalToConstant: 20),
            commentButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: 80),
            likeButton.topAnchor.constraint(equalTo: twitterTextLabel.bottomAnchor, constant: 10),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            likeButton.widthAnchor.constraint(equalToConstant: 20),
            likeButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 80),
            retweetButton.topAnchor.constraint(equalTo: twitterTextLabel.bottomAnchor, constant: 10),
            retweetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            retweetButton.widthAnchor.constraint(equalToConstant: 20),
            retweetButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: retweetButton.leadingAnchor, constant: 80),
            shareButton.topAnchor.constraint(equalTo: twitterTextLabel.bottomAnchor, constant: 10),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: 20),
            shareButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        let commentCountLabelConstraints = [
            commentCountLabel.topAnchor.constraint(equalTo: commentButton.topAnchor),
            commentCountLabel.bottomAnchor.constraint(equalTo: commentButton.bottomAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 10),
            commentCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor)
        ]
        let likeCountLabelConstraints = [
            likesCountLabel.topAnchor.constraint(equalTo: likeButton.topAnchor),
            likesCountLabel.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor),
            likesCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 10),
            likesCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: retweetButton.leadingAnchor)
        ]
        let retweetCountLabelConstraints = [
            retweetsCountLabel.topAnchor.constraint(equalTo: retweetButton.topAnchor),
            retweetsCountLabel.bottomAnchor.constraint(equalTo: retweetButton.bottomAnchor),
            retweetsCountLabel.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: 10),
            retweetsCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: shareButton.leadingAnchor)
        ]
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(twitterTextLabelConstraints)
        NSLayoutConstraint.activate(userHandleLabelConstraints)
        NSLayoutConstraint.activate(commentButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
        NSLayoutConstraint.activate(commentCountLabelConstraints)
        NSLayoutConstraint.activate(likeCountLabelConstraints)
        NSLayoutConstraint.activate(retweetCountLabelConstraints)
    }
    
    public func configure(with model: TweetModel){
        tweetModel = model
        userHandleLabel.text = "@\(model.userHandle ?? "unknown")"
        userNameLabel.text = model.username ?? "Unknown"
        twitterTextLabel.text = model.text
        
        commentsCount = model.comments?.count ?? 0
        commentCountLabel.text = String(commentsCount)
        
        likesCount = model.likers.count
        likesCountLabel.text = String(likesCount)
        
        if model.likers.contains(DatabaseManager.shared.currentUser.userName) {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .red
        }
        
        retweetsCount = model.retweets ?? 0
        retweetsCountLabel.text = String(retweetsCount)
    }
    
    public func configureComment(with model: CommentsModel){
        commentModel = model
        userHandleLabel.text = "@\(model.userHandle ?? "unknown")"
        userNameLabel.text = model.username ?? "Unknown"
        twitterTextLabel.text = model.text
    
        likesCount = model.likes ?? 0
        likesCountLabel.text = String(likesCount)
        
        retweetsCount = model.retweets ?? 0
        retweetsCountLabel.text = String(retweetsCount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tweetModel = nil
        commentModel = nil
        userHandleLabel.text = ""
        userNameLabel.text = nil
        twitterTextLabel.text = nil
        commentsCount = 0
        commentCountLabel.text = nil
        likesCount = 0
        likesCountLabel.text = nil
        retweetsCount = 0
        retweetsCountLabel.text = nil
    }
 
//MARK: - Action
    
    private func addActions() {
        commentButton.addTarget(self, action: #selector(tappedCommentButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(tappedRetweetButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tappedShareButton), for: .touchUpInside)
    }
    
    @objc private func tappedCommentButton() {
        delegate?.didTapCommentButton()
    }
    
    @objc private func tappedLikeButton() {
        
        if let tweetModel = tweetModel {
            if likeButton.tintColor == .red {
                let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
                likeButton.setImage(image, for: .normal)
                likeButton.tintColor = .label
                likesCount -= 1
                likesCountLabel.text = String(likesCount)
                delegate?.didTapLikeButton(liked: false, model: tweetModel)
            }
            else {
                let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
                likeButton.setImage(image, for: .normal)
                likeButton.tintColor = .red
                likesCount += 1
                likesCountLabel.text = String(likesCount)
                delegate?.didTapLikeButton(liked: true, model: tweetModel)
            }
        }
        else if let commentModel = commentModel {
            if likeButton.tintColor == .red {
                let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
                likeButton.setImage(image, for: .normal)
                likeButton.tintColor = .label
                delegate?.didTapLikeButtonInComment(liked: false, model: commentModel)
            }
            else {
                let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
                likeButton.setImage(image, for: .normal)
                likeButton.tintColor = .red
                delegate?.didTapLikeButtonInComment(liked: true, model: commentModel)
            }
        }
        else {return}
    }
    
    @objc private func tappedRetweetButton() {
        if retweetButton.tintColor == .systemGreen {
            retweetButton.tintColor = .label
            //undo retweet state
        }
        else {
            if var tweetModel = tweetModel {
                delegate?.didTapRetweet(with: tweetModel, completion: {[weak self] result in
                    DispatchQueue.main.async {
                        if result {
                            self?.retweetButton.tintColor = .systemGreen
                            tweetModel.isRetweetedByUser = true
                        }
                    }
                })
            }
            else if var commentModel = commentModel {
                delegate?.didTapRetweetInComment(with: commentModel, completion: {[weak self] result in
                    DispatchQueue.main.async {
                        if result {
                            self?.retweetButton.tintColor = .systemGreen
                            commentModel.isRetweetedByUser = true
                        }
                    }
                })
            }
            else {return}
        }
    }
    
    @objc private func tappedShareButton() {
        delegate?.didTapShareButton()
    }
}
