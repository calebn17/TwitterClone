//
//  SelectedTweetHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/25/22.
//

import UIKit

class SelectedTweetHeaderView: UIView {
    
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.tintColor = .label
        label.backgroundColor = .red
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userHandleLabel: UILabel = {
        let label = UILabel()
        label.text = "@userhandle"
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.tintColor = .systemGray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tweetBodyLabel: UILabel = {
        let label = UILabel()
        label.text = "Text Body of the tweet"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
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
        label.tintColor = .systemGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tweet: TweetModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
        addSubViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(userHandleLabel)
        addSubview(tweetBodyLabel)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(retweetButton)
        addSubview(shareButton)
        addSubview(dateCreatedLabel)
    }
    
    private func addConstraints() {
        let profileImageViewConstraints = [
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileImageView.heightAnchor.constraint(equalToConstant: K.userImageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let usernameLabelConstraints = [
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10)
        ]
        let userHandleLabelConstraints = [
            userHandleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 7),
            userHandleLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 7)
        ]
        let tweetBodyLabelConstraints = [
            tweetBodyLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            tweetBodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tweetBodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        ]
        let dateCreatedLabelConstraints = [
            dateCreatedLabel.topAnchor.constraint(equalTo: tweetBodyLabel.bottomAnchor, constant: 30),
            dateCreatedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ]
        let spaceBetweenButtons = (width - 20*4)/5
        let commentButtonConstraints = [
            commentButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spaceBetweenButtons),
            commentButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30)
        ]
        let retweetButtonConstraints = [
            retweetButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: spaceBetweenButtons),
            retweetButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30)
        ]
        let likeButtonConstraints = [
            likeButton.leadingAnchor.constraint(equalTo: retweetButton.trailingAnchor, constant: spaceBetweenButtons),
            likeButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30)
        ]
        let shareButtonConstraints = [
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: spaceBetweenButtons),
            shareButton.topAnchor.constraint(equalTo: dateCreatedLabel.bottomAnchor, constant: 30)
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
    }
    
}
