//
//  HomeTweetTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import UIKit

class HomeTweetTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTweetTableViewCell"
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let twitterTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(userNameLabel)
        addSubview(userImage)
        addSubview(twitterTextLabel)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        let userImageConstraints = [
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let userNameLabelConstraints = [
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
        ]
        let twitterTextLabel = [
            twitterTextLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 20),
            twitterTextLabel.leadingAnchor.constraint(equalTo: userNameLabel.leadingAnchor),
            twitterTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),
            twitterTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ]
        
        NSLayoutConstraint.activate(userImageConstraints)
        NSLayoutConstraint.activate(userNameLabelConstraints)
        NSLayoutConstraint.activate(twitterTextLabel)
    }
    
    public func configure(with model: HomeTweetViewCellViewModel){
        userNameLabel.text = model.userName
        twitterTextLabel.text = model.tweetBody
    }
}
