//
//  SelectedTweetHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

protocol SelectedTweetHeaderTableViewCellDelegate: AnyObject {
    func didTapCommentButton()
    func didTapRetweet(with model: TweetModel, completion: @escaping (Bool) -> Void)
    func didTapLikeButton(liked: Bool, model: TweetModel)
    func didTapShareButton()
}

class SelectedTweetHeaderTableViewCell: UITableViewCell {

//MARK: - Setup
    
    static let identifier = "SelectedTweetHeaderTableViewCell"
    public weak var delegate: SelectedTweetHeaderTableViewCellDelegate?
    private var tweet: TweetModel?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = K.userImageSize/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.tintColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHandleLabel: UILabel = {
        let label = UILabel()
        label.text = "@userhandle"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tweetBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Text Body of the tweet"
        label.numberOfLines = 0
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.tintColor = .label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bubble.left", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.2.squarepath", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let dateCreatedLabel: UILabel = {
        let label = UILabel()
        label.text = "Date Value"
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

//MARK: - Init Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
//MARK: - Configure Methods
    
    private func addSubViews() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(userHandleLabel)
        contentView.addSubview(tweetBodyLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(dateCreatedLabel)
    }
    
    private func addConstraints() {
        let profileImageViewConstraints = [
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: K.userImageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let usernameLabelConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        ]
        let userHandleLabelConstraints = [
            userHandleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7),
            userHandleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 7)
        ]
        let tweetBodyLabelConstraints = [
            tweetBodyLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            tweetBodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tweetBodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        let dateCreatedLabelConstraints = [
            dateCreatedLabel.topAnchor.constraint(equalTo: tweetBodyLabel.bottomAnchor, constant: 30),
            dateCreatedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ]
        let spaceBetweenButtons = (contentView.width - shareButton.width*4)/5
        let commentButtonConstraints = [
            commentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spaceBetweenButtons),
            commentButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30),
            commentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: spaceBetweenButtons),
            retweetButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30),
            retweetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: spaceBetweenButtons),
            likeButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: spaceBetweenButtons),
            shareButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(userHandleLabelConstraints)
        NSLayoutConstraint.activate(tweetBodyLabelConstraints)
        NSLayoutConstraint.activate(dateCreatedLabelConstraints)
        NSLayoutConstraint.activate(commentButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
    }
    
    public func configure(with tweet: TweetModel) {
        self.tweet = tweet
        tweetBodyLabel.text = tweet.text
        usernameLabel.text = tweet.username ?? "UserName"
        userHandleLabel.text = "@\(tweet.userHandle ?? "userhandle")"
    }
    
//MARK: - Action Methods
    
    private func addActions() {
        commentButton.addTarget(self, action: #selector(didTapCommentButton), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(didTapRetweetButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc private func didTapCommentButton() {
        delegate?.didTapCommentButton()
    }
    
    @objc private func didTapRetweetButton() {
        if retweetButton.tintColor == .systemGreen {
            retweetButton.tintColor = .label
            //undo retweet state
        }
        else {
            guard var tweetModel = tweet else {return}
            delegate?.didTapRetweet(with: tweetModel, completion: {[weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.retweetButton.tintColor = .systemGreen
                        tweetModel.isRetweetedByUser = true
                    }
                }
            })
        }
    }
    
    @objc private func didTapLikeButton() {
        
        guard let tweetModel = tweet else {return}
        if likeButton.tintColor == .red {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
            delegate?.didTapLikeButton(liked: false, model: tweetModel)
        }
        else {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:20))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .red
            delegate?.didTapLikeButton(liked: true, model: tweetModel)
        }
    }
    
    @objc private func didTapShareButton() {
        delegate?.didTapShareButton()
    }
}
