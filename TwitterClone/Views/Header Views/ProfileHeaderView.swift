//
//  ProfileHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit
import SDWebImage

class ProfileHeaderView: UIView {

//MARK: - Properties
    
    private let imageSize: CGFloat = K.userImageSize
    
//MARK: - Subviews
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = K.userImageSize/2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.image = UIImage(systemName: "person")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "name"
        return label
    }()
    
    private let handleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .tertiaryLabel
        label.numberOfLines = 1
        label.text = "@handle"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "This is a little bit of information about myself!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "# following"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "# followers"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubViews()
        configureConstraints()
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
    }
    
//MARK: - Configure
    
    func configure(with model: ProfileHeaderViewModel) {
        profileImageView.sd_setImage(with: model.profileImage, completed: nil)
        nameLabel.text = model.userName
        handleLabel.text = model.userHandle
        bioLabel.text = model.bio
        followingLabel.text = "\(model.followingCount ?? 0) Following"
        followersLabel.text = "\(model.followerCount ?? 0) Followers"
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
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            bioLabel.heightAnchor.constraint(equalToConstant: bounds.height/5),
            bioLabel.widthAnchor.constraint(equalToConstant: bounds.width - 30)
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
        NSLayoutConstraint.activate(profileImageViewContraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(handleLabelConstraints)
        NSLayoutConstraint.activate(bioLabelConstraints)
        NSLayoutConstraint.activate(followingLabelConstraints)
        NSLayoutConstraint.activate(followersLabelConstraints)
    }
}
