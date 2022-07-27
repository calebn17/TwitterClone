//
//  ProfileHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit
import SDWebImage

protocol ProfileHeaderViewDelegate: AnyObject {
    func didTapOnFollowButton(didFollow: Bool)
    func didTapOnProfilePicture()
}

class ProfileHeaderView: UIView {

//MARK: - Properties
    weak var delegate: ProfileHeaderViewDelegate?
    private let imageSize: CGFloat = K.userImageSize
    private var currentUser: User {
        return DatabaseManager.shared.currentUser
    }
    private var model: ProfileHeaderViewModel?
    
    
//MARK: - Subviews
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.layer.cornerRadius = K.userImageSize/2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let handleLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let bioLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let followingLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let followersLabel: CustomLabel = {
        let label = CustomLabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let followButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = K.userImageSize/2.4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.isHidden = true
        return button
    }()
   
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubViews()
        configureConstraints()
        addActions()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addSubViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(handleLabel)
        addSubview(bioLabel)
        addSubview(followingLabel)
        addSubview(followersLabel)
        addSubview(followButton)
    }
    
//MARK: - Configure
    
    func configure(with model: ProfileHeaderViewModel) {
        self.model = model
        
        if model.profileImage == nil {
            profileImageView.image = UIImage(systemName: "person")
        } else {
            profileImageView.sd_setImage(with: model.profileImage, completed: nil)
        }
        nameLabel.text = model.userName
        handleLabel.text = "@\(model.userHandle)"
        bioLabel.text = model.bio
        followingLabel.text = "\(model.following.count) Following"
        followersLabel.text = "\(model.followers.count) Followers"
        configureFollowButton()
    }
    
    private func configureFollowButton() {
        guard let model = self.model else {return}
        
        if model.userName == currentUser.userName {
            followButton.isHidden = true
        }
        else {
            followButton.isHidden = false
            
            // If the current user is a follower of the viewed user, then show the Unfollow button
            if model.followers.contains(currentUser.userName) {
                configureFollowButtonState(showFollow: false)
            } else {
                configureFollowButtonState(showFollow: true)
            }
        }
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
    }
    
    private func configureFollowButtonState(showFollow: Bool) {
        if showFollow {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.systemBackground, for: .normal)
            followButton.backgroundColor = .label
            followButton.layer.borderColor = UIColor.systemBackground.cgColor
        }
        else {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    private func addActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePicture))
        profileImageView.addGestureRecognizer(tap)
    }
    
//MARK: - Actions
    
    @objc private func didTapProfilePicture() {
        delegate?.didTapOnProfilePicture()
    }
    
    @objc private func didTapFollowButton() {
        guard let model = self.model else {return}
        
        
        if model.followers.contains(currentUser.userName) {
            // Already following -> unfollow
            print("unfollowing")
            configureFollowButtonState(showFollow: true)
            delegate?.didTapOnFollowButton(didFollow: false)
        } else {
            // Not following -> follow
            print("following")
            configureFollowButtonState(showFollow: false)
            delegate?.didTapOnFollowButton(didFollow: true)
        }
    }
    
//MARK: - Constraints
    private func configureConstraints() {
        let profileImageViewContraints = [
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: imageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ]
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
        ]
        let handleLabelConstraints = [
            handleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            handleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
        ]
        let bioLabelConstraints = [
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bioLabel.topAnchor.constraint(equalTo: handleLabel.bottomAnchor, constant: 15),
            bioLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15),
            bioLabel.heightAnchor.constraint(equalToConstant: bounds.height/5)
        ]
        let followingLabelConstraints = [
            followingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followingLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15),
            followingLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 10)
        ]
        let followersLabelConstraints = [
            followersLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, constant: 10),
            followersLabel.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 15),
            followersLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 10)
        ]
        let followButtonConstraints = [
            followButton.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 20),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            followButton.widthAnchor.constraint(equalToConstant: imageSize*2)
        ]
        NSLayoutConstraint.activate(profileImageViewContraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(handleLabelConstraints)
        NSLayoutConstraint.activate(bioLabelConstraints)
        NSLayoutConstraint.activate(followingLabelConstraints)
        NSLayoutConstraint.activate(followersLabelConstraints)
        NSLayoutConstraint.activate(followButtonConstraints)
    }
}
