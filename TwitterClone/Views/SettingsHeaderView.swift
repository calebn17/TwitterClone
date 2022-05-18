//
//  SettingsHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/14/22.
//

import UIKit

protocol SettingsHeaderViewDelegate: AnyObject {
    func didTapAccountsButton()
}

class SettingsHeaderView: UIView {

//MARK: - Setup
    
    public weak var delegate: SettingsHeaderViewDelegate?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let followingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("# Following", for: .normal)
        return button
    }()
    
    private let followersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("# Followers", for: .normal)
        return button
    }()
    
    private let userNameButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("User Name", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let userHandleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("@userHandle", for: .normal)
        button.setTitleColor(.secondaryLabel, for: .normal)
        return button
    }()
    
    private let accountsButton: UIButton = {
        let button = UIButton()
        let image =  UIImage(systemName: "person.3")
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        return button
    }()
 
//MARK: - Init and View Methods
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
  
//MARK: - Configure Methods
    
    private func configureConstraints() {
        let userImageViewConstraints = [
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: K.userImageSize),
            userImageView.heightAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let userNameButtonConstraints = [
            userNameButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5),
            userNameButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ]
        let userHandleButtonConstraints = [
            userHandleButton.topAnchor.constraint(equalTo: userNameButton.bottomAnchor, constant: 5),
            userHandleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userHandleButton.heightAnchor.constraint(equalToConstant: userNameButton.height/1.5)
        ]
        let followingButtonConstraints = [
            followingButton.topAnchor.constraint(equalTo: userHandleButton.bottomAnchor, constant: 30),
            followingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
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
    
    public func configure(with model: String) {
        
    }
    
//MARK: - Action Methods
    
    @objc private func didTapAccountsButton() {
        delegate?.didTapAccountsButton()
    }
}
