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
    
    private let userImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .label
        imageView.layer.cornerRadius = K.userImageSize/2
        return imageView
    }()
    
    private let titleLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "default title"
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "default subtitle"
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
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

//MARK: - Lifecycle
    private func addSubviews(){
        contentView.addSubview(userImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(actionImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actionImageView.image = UIImage(systemName: "heart")
        actionImageView.tintColor = .label
        actionImageView.image = UIImage(systemName: "message")
        actionImageView.tintColor = .label
        actionImageView.image = UIImage(systemName: "arrow.2.squarepath")
        actionImageView.tintColor = .label
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
//MARK: - Configure
    func configure(with model: NotificationsModel) {
        
        switch model.action {
            
        // liked
        case 1:
            actionImageView.image = UIImage(systemName: "heart.fill")
            actionImageView.tintColor = .red
            titleLabel.text = "\(model.senderUserName) liked your tweet!"
            subtitleLabel.text = model.model.text
        // comment
        case 2:
            actionImageView.image = UIImage(systemName: "message.fill")
            actionImageView.tintColor = .systemCyan
            titleLabel.text = "\(model.senderUserName) commented!"
            subtitleLabel.text = model.model.text
        
        // retweet
        case 3:
            actionImageView.image = UIImage(systemName: "arrow.2.squarepath")
            actionImageView.tintColor = .systemGreen
            titleLabel.text = "\(model.senderUserName) retweeted your tweet!"
            subtitleLabel.text = model.model.text
            
        // followed
        case 4:
            actionImageView.image = UIImage(named: "twitterLogo")
            actionImageView.tintColor = .clear
        default:
            break
        }
    }
}

//MARK: - Constraints
extension Notifications_All_TableViewCell {
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
            actionImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            actionImageView.heightAnchor.constraint(equalToConstant: imageSize),
            actionImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ]
        
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(subtitleLabelConstraints)
        NSLayoutConstraint.activate(actionImageViewConstraints)
    }
}
