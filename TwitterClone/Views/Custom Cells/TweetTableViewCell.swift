//
//  HomeTweetTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import UIKit

protocol TweetTableViewCellDelegate: AnyObject {
    func didTapCommentButton()
    func didTapRetweet(with model: HomeTweetViewCellViewModel, completion: @escaping (Bool) -> Void)
    func didTapLikeButton(liked: Bool)
    func didTapShareButton()
}
///Individual Tweet Cell
class TweetTableViewCell: UITableViewCell {

//MARK: - Setup
    
    static let identifier = "HomeTweetTableViewCell"
    
    public weak var delegate: TweetTableViewCellDelegate?
    
    private var tweetModel: HomeTweetViewCellViewModel?
    
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
  
//MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //add contentView here so that autolayout constraints work and automatically resize
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userImage)
        contentView.addSubview(twitterTextLabel)
        contentView.addSubview(userHandleLabel)
        contentView.addSubview(commentButton)
        contentView.addSubview(likeButton)
        contentView.addSubview(retweetButton)
        contentView.addSubview(shareButton)
        configureConstraints()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Configure
    private func configureConstraints() {
        
        let userImageConstraints = [
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20),
            //userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let twitterTextLabelConstraints = [
            twitterTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            twitterTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            twitterTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            //twitterTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ]
        let userHandleLabelConstraints = [
            userHandleLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 5),
            //userHandleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
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
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(twitterTextLabelConstraints)
        NSLayoutConstraint.activate(userHandleLabelConstraints)
        NSLayoutConstraint.activate(commentButtonConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(retweetButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
    }
    
    public func configure(with model: HomeTweetViewCellViewModel){
        tweetModel = model
        userHandleLabel.text = "@\(model.userName)"
        userNameLabel.text = model.userName
        twitterTextLabel.text = model.tweetBody
    }
 
//MARK: - Action Methods
    
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
        
        if likeButton.tintColor == .red {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
            delegate?.didTapLikeButton(liked: false)
        }
        else {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize:15))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .red
            delegate?.didTapLikeButton(liked: true)
        }
    }
    
    @objc private func tappedRetweetButton() {
        if retweetButton.tintColor == .systemGreen {
            retweetButton.tintColor = .label
            //undo retweet state
        }
        else {
            guard let tweetModel = tweetModel else {return}
            delegate?.didTapRetweet(with: tweetModel, completion: {[weak self] result in
                DispatchQueue.main.async {
                    if result {
                        self?.retweetButton.tintColor = .systemGreen
                    }
                }
            })
        }
    }
    
    @objc private func tappedShareButton() {
        delegate?.didTapShareButton()
    }
}
