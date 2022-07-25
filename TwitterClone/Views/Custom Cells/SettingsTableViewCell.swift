//
//  SettingsTableViewCell.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/14/22.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

//MARK: - Properties
    static let identifier = "SettingsTableViewCell"
    
    
//MARK: - Subviews
    public let label: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "list.bullet.rectangle")
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Lifecycle
    override func prepareForReuse() {
        label.text = nil
        iconImageView.image = nil
        label.textColor = .label
    }

//MARK: - Configure/Constraints
    private func addConstraints() {
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 40),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    public func configure(with model: SettingsViewModel) {
        label.text = model.title
        iconImageView.image = UIImage(systemName: model.icon ?? "")
        
        if model.title == "TwitterBlue" {
            iconImageView.tintColor = .systemBlue
        }
        if model.title == "Sign Out" {
            label.textColor = .systemRed
        }
    }
}
