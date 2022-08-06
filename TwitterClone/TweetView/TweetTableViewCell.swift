//
//  HomeTweetTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import UIKit

//MARK: - Protocol
protocol TweetTableViewCellDelegate: AnyObject {
    func tweetTableViewCellDidTapCommentButton(owner: TweetModel)
    func tweetTableViewCellDidTapRetweet(
        retweeted: Bool,
        model: TweetModel,
        completion: @escaping (Bool) -> Void
    )
    func tweetTableViewCellDidTapLikeButton(liked: Bool, model: TweetModel)
    func tweetTableViewCellDidTapShareButton(tweet: TweetModel)
    func tweetTableViewCellDidTapProfilePicture(user: User)
}
///Individual Tweet Cell
final class TweetTableViewCell: UITableViewCell {

//MARK: - Properties
    static let identifier = "HomeTweetTableViewCell"
    public weak var delegate: TweetTableViewCellDelegate?
    private var model: TweetModel?
    private var viewModel = TweetViewModel()
    private var likesCount = 0
    private var commentsCount = 0
    private var retweetsCount = 0
    private var isCurrentlyLikedByCurrentUser = false
    private var isRetweetedByCurrentUser = false
    private var isCommentedByCurrentUser = false
    private var currentUser: User { return TweetViewModel().currentUser }
    
//MARK: - SubViews
    private let userNameLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let userImage: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        imageView.layer.cornerRadius = 25
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let twitterTextLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let userHandleLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .systemGray
        return label
    }()
    
    private let commentButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "bubble.left", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let likeButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let retweetButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "arrow.2.squarepath", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let shareButton: CustomButton = {
        let button = CustomButton()
        let image = UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let commentCountLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let likesCountLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let retweetsCountLabel: CustomLabel = {
        let label = CustomLabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15)
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
    
//MARK: - Lifecycle
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
        userHandleLabel.text = ""
        userNameLabel.text = nil
        twitterTextLabel.text = nil
        commentsCount = 0
        commentCountLabel.text = nil
        likesCount = 0
        likesCountLabel.text = nil
        retweetsCount = 0
        retweetsCountLabel.text = nil
        likeButton.tintColor = .label
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        retweetButton.tintColor = .label
        userImage.image = nil
        likeButton.tintColor = .label
        commentButton.tintColor = .label
        retweetButton.tintColor = .label
    }
    
//MARK: - Configure
    public func configure(with model: TweetModel){
        self.model = model
        fetchUserImage(with: model)
        updateUserImageUI()

        userHandleLabel.text = "@\(model.userHandle)"
        userNameLabel.text = model.username
        twitterTextLabel.text = model.text
        
        commentsCount = model.comments.count
        commentCountLabel.text = String(commentsCount)
        if model.comments.contains(where: { $0.username == currentUser.userName }) {
            commentButton.tintColor = .systemCyan
            isCommentedByCurrentUser = true
        }
        
        likesCount = model.likers.count
        likesCountLabel.text = String(likesCount)
        if model.likers.contains(DatabaseManager.shared.currentUser.userName) {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .red
            isCurrentlyLikedByCurrentUser = true
        }
        
        retweetsCount = model.retweeters.count
        retweetsCountLabel.text = String(retweetsCount)
        if model.retweeters.contains(DatabaseManager.shared.currentUser.userName) {
            retweetButton.tintColor = .systemGreen
            isRetweetedByCurrentUser = true
        }
    }
    
    private func updateUserImageUI() {
        viewModel.profilePictureURL.bind {[weak self] url in
            DispatchQueue.main.async {
                guard let url = url else {return}
                self?.userImage.sd_setImage(with: url, completed: nil)
            }
        }
    }

//MARK: - Networking
    private func fetchUserImage(with model: TweetModel) {
        Task {
            try await viewModel.fetchProfilePictureURL(tweet: model)
        }
    }
 
//MARK: - Action
    
    private func addActions() {
        commentButton.addTarget(self, action: #selector(tappedCommentButton), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(tappedLikeButton), for: .touchUpInside)
        retweetButton.addTarget(self, action: #selector(tappedRetweetButton), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(tappedShareButton), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnProfilePicture))
        userImage.addGestureRecognizer(tap)
    }
    
    @objc private func tappedOnProfilePicture() {
        
        guard let model = self.model else {return}
        let user = User(
            id: nil,
            userName: model.username,
            userHandle: model.userHandle,
            userEmail: model.userEmail
        )
        delegate?.tweetTableViewCellDidTapProfilePicture(user: user)
    }
    
    @objc private func tappedCommentButton() {
        guard let model = self.model else {return}
        delegate?.tweetTableViewCellDidTapCommentButton(owner: model)
    }
    
    @objc private func tappedLikeButton() {
        guard let model = self.model else {return}
        
        // tapping this button will unlike tweet
        if isCurrentlyLikedByCurrentUser == true {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
            if likesCount > 0 {
                likesCount -= 1
                likesCountLabel.text = String(likesCount)
            }
        }
        // tapping this button will like tweet
        else {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .red
            likesCount += 1
            likesCountLabel.text = String(likesCount)
        }
        
        delegate?.tweetTableViewCellDidTapLikeButton(liked: !isCurrentlyLikedByCurrentUser, model: model)
        
        isCurrentlyLikedByCurrentUser = !isCurrentlyLikedByCurrentUser
    }
    
    @objc private func tappedRetweetButton() {
        guard let model = self.model else {return}
        
        // Un-retweet
        if isRetweetedByCurrentUser {
            delegate?.tweetTableViewCellDidTapRetweet(retweeted: !isRetweetedByCurrentUser, model: model, completion: {[weak self] success in
                guard let strongIsRetweetedByCurrentUser = self?.isRetweetedByCurrentUser else {return}
                if success {
                    self?.isRetweetedByCurrentUser = !strongIsRetweetedByCurrentUser
                }
            })
            retweetButton.tintColor = .label
            if retweetsCount > 0 {
                retweetsCount -= 1
                retweetsCountLabel.text = String(retweetsCount)
            }
        }
        //Retweet
        else {
            delegate?.tweetTableViewCellDidTapRetweet(retweeted: !isRetweetedByCurrentUser, model: model, completion: { [weak self] success in
                DispatchQueue.main.async {
                    guard let strongIsRetweetedByCurrentUser = self?.isRetweetedByCurrentUser else {return}
                    if success {
                        self?.retweetButton.tintColor = .systemGreen
                        self?.retweetsCount += 1
                        self?.retweetsCountLabel.text = String(self?.retweetsCount ?? 0)
                        self?.isRetweetedByCurrentUser = !strongIsRetweetedByCurrentUser
                    }
                }
            })
        }
    }
    
    @objc private func tappedShareButton() {
        guard let model = self.model else {return}
        delegate?.tweetTableViewCellDidTapShareButton(tweet: model)
    }
}

//MARK: - Constraints
extension TweetTableViewCell {
    
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
    
}
