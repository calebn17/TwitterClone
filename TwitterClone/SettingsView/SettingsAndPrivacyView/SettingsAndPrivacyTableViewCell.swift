//
//  SettingsAndPrivacyTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/18/22.
//

import UIKit

final class SettingsAndPrivacyTableViewCell: UITableViewCell {
    
//MARK: - Properties
    
    static let identifier = "SettingsAndPrivacyTableViewCell"
    
//MARK: - Subviews
    private let titleLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.tintColor = .label
        return label
    }()
    
    private let descriptionLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "Description"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.tintColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let iconImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.image = UIImage(systemName: "person", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15))
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
//MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(iconImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - Configure
    func configure(with model: SettingsAndPrivacyViewModel) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        iconImageView.image = UIImage(systemName: model.icon)
    }
    
//MARK: - Constraints
    private func addConstraints() {
        
        let imageSize = K.userImageSize/2
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: imageSize),
            iconImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20)
        ]
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
}
