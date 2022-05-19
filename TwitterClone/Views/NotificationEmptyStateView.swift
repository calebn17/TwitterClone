//
//  NotificationEmptyStateView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/19/22.
//

import UIKit

class NotificationEmptyStateView: UIView {

//MARK: - Setup
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Oops! You have no Notifications..."
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bell", withConfiguration: UIImage.SymbolConfiguration(pointSize: 100, weight: .regular))
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        return imageView
    }()

//MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(emptyStateImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 //MARK: - Configure Methods
    
    private func addConstraints() {
        
        let size: CGFloat = 200
        
        let emptyStateImageViewConstraints = [
            emptyStateImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            emptyStateImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: size),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: size)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 10),
            //titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 70),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(emptyStateImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}
