//
//  SettingsHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/14/22.
//

import UIKit
import FirebaseAuth

protocol SettingsHeaderViewDelegate: AnyObject {
    func didTapAccountsButton()
}

class SettingsHeaderView: UIView {

//MARK: - Properties
    
    public weak var delegate: SettingsHeaderViewDelegate?
    
//MARK: - Subviews
    private let userImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .label
        imageView.layer.cornerRadius = K.userImageSize/2
        return imageView
    }()
    
    private let followingButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("# Following", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.masksToBounds = false
        return button
    }()
    
    private let followersButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("# Followers", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.layer.masksToBounds = false
        return button
    }()
    
    public let userNameButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("User Name", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    public let userHandleButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("@userHandle", for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .normal)
        button.layer.masksToBounds = false
        return button
    }()
    
    private let accountsButton: CustomButton = {
        let button = CustomButton()
        let image =  UIImage(systemName: "person.3")
        button.tintColor = .label
        button.setImage(image, for: .normal)
        return button
    }()
 
//MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        configureConstraints()
        accountsButton.addTarget(self, action: #selector(didTapAccountsButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addSubviews() {
        addSubview(userImageView)
        addSubview(followingButton)
        addSubview(followersButton)
        addSubview(userNameButton)
        addSubview(userHandleButton)
        addSubview(accountsButton)
    }
    
//MARK: - Configure
    func configure(with viewModel: SettingsHeaderViewModel) {
        if let url = viewModel.profilePictureURL {
            userImageView.sd_setImage(with: url, completed: nil)
        } else {
            userImageView.image = UIImage(systemName: "person")
        }
        userNameButton.setTitle(viewModel.username, for: .normal)
        userHandleButton.setTitle("@\(viewModel.userhandle)", for: .normal)
        followersButton.setTitle("\(viewModel.followers.count) Follower", for: .normal)
        followingButton.setTitle("\(viewModel.following.count) Following", for: .normal)
    }
    
//MARK: - Action Methods
    @objc private func didTapAccountsButton() {
        delegate?.didTapAccountsButton()
    }
}

//MARK: - Constraints
extension SettingsHeaderView {
    private func configureConstraints() {
        let userImageViewConstraints = [
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: K.userImageSize),
            userImageView.heightAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let userNameButtonConstraints = [
            userNameButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5),
            userNameButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        let userHandleButtonConstraints = [
            userHandleButton.topAnchor.constraint(equalTo: userNameButton.bottomAnchor, constant: 5),
            userHandleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userHandleButton.heightAnchor.constraint(equalToConstant: userNameButton.height/1.5)
        ]
        let followingButtonConstraints = [
            followingButton.topAnchor.constraint(equalTo: userHandleButton.bottomAnchor, constant: 30),
            followingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followingButton.heightAnchor.constraint(equalToConstant: userNameButton.height/1.5)
        ]
        let followersButtonConstraints = [
            followersButton.topAnchor.constraint(equalTo: userHandleButton.bottomAnchor, constant: 30),
            followersButton.leadingAnchor.constraint(equalTo: followingButton.trailingAnchor, constant: 10),
            followersButton.heightAnchor.constraint(equalToConstant: userNameButton.height/1.5)
        ]
        let accountsButtonConstraints = [
            accountsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            accountsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            accountsButton.heightAnchor.constraint(equalToConstant: K.userImageSize),
            accountsButton.widthAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(userNameButtonConstraints)
        NSLayoutConstraint.activate(userHandleButtonConstraints)
        NSLayoutConstraint.activate(followingButtonConstraints)
        NSLayoutConstraint.activate(followersButtonConstraints)
        NSLayoutConstraint.activate(accountsButtonConstraints)
    }
}
