//
//  Notifications_All_TableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/19/22.
//

import UIKit

class Notifications_All_TableViewCell: UITableViewCell {

//MARK: - Setup
    
    static let identifier = "Notifications_All_TableViewCell"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .label
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = K.userImageSize/2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "default title"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "default subtitle"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//MARK: - Init Methods
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        contentView.addSubview(userImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(actionImageView)
    }
    
    private func addConstraints() {
        let imageSize = K.userImageSize
        let userImageViewConstraints = [
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            userImageView.leadingAnchor.constraint(equalTo: actionImageView.trailingAnchor, constant: 20),
            userImageView.heightAnchor.constraint(equalToConstant: imageSize),
            userImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        let subtitleLabelConstraints = [
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        let actionImageViewConstraints = [
            actionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionImageView.heightAnchor.constraint(equalToConstant: imageSize),
            actionImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ]
        
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(subtitleLabelConstraints)
        NSLayoutConstraint.activate(actionImageViewConstraints)
    }
    
    func configure(with model: NotificationsVCViewModel) {
        titleLabel.text = "\(model.userName) \(model.action) your tweet!"
        subtitleLabel.text = model.tweetBody
        
        switch model.action {
        case .followed:
            actionImageView.image = UIImage(named: "twitterLogo")
            actionImageView.tintColor = .clear
        case .liked:
            actionImageView.image = UIImage(systemName: "heart.fill")
            actionImageView.tintColor = .red
        case .reply:
            break
        case .retweet:
            break
        }
    }
    
}
