//
//  NotificationsHeaderView.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/19/22.
//

import UIKit

protocol NotificationsHeaderViewDelegate: AnyObject {
    func tappedAllButton()
    func tappedMentionsButton()
}

final class NotificationsHeaderView: UIView {
    
//MARK: - Setup
    
    weak var delegate: NotificationsHeaderViewDelegate?
    
    private let allButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("All", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 0
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemBackground
        return button
    }()
    
    private let mentionsButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Mentions", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.borderWidth = 0
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = .systemBackground
        return button
    }()
    
    private let allButtonIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mentionsButtonIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemCyan
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
//MARK: - Init/View Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        allButton.addTarget(self, action: #selector(didTapAllButton), for: .touchUpInside)
        mentionsButton.addTarget(self, action: #selector(didTapMentionsButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addSubviews() {
        addSubview(allButton)
        addSubview(mentionsButton)
        addSubview(allButtonIndicator)
        addSubview(mentionsButtonIndicator)
    }
 //MARK: - Configure Methods
    
    private func addConstraints() {
        let size = width/2
        
        let allButtonConstraints = [
            allButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            allButton.widthAnchor.constraint(equalToConstant: size),
            allButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let mentionsButtonConstraints = [
            mentionsButton.leadingAnchor.constraint(equalTo: allButton.trailingAnchor),
            mentionsButton.heightAnchor.constraint(equalToConstant: 40),
            mentionsButton.widthAnchor.constraint(equalToConstant: size)
        ]
        let allButtonIndicatorConstraints = [
            allButtonIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            allButtonIndicator.topAnchor.constraint(equalTo: allButton.bottomAnchor),
            allButtonIndicator.widthAnchor.constraint(equalToConstant: size),
            allButtonIndicator.heightAnchor.constraint(equalToConstant: 5)
        ]
        let mentionsButtonIndicatorConstraints = [
            mentionsButtonIndicator.leadingAnchor.constraint(equalTo: allButtonIndicator.trailingAnchor),
            mentionsButtonIndicator.topAnchor.constraint(equalTo: mentionsButton.bottomAnchor),
            mentionsButtonIndicator.widthAnchor.constraint(equalToConstant: size),
            mentionsButtonIndicator.heightAnchor.constraint(equalToConstant: 5)
        ]
        NSLayoutConstraint.activate(allButtonConstraints)
        NSLayoutConstraint.activate(mentionsButtonConstraints)
        NSLayoutConstraint.activate(allButtonIndicatorConstraints)
        NSLayoutConstraint.activate(mentionsButtonIndicatorConstraints)
    }
    
//MARK: - Action Methods
    
    @objc private func didTapAllButton() {
        UIView.animate(withDuration: 0.2) {
            //animate later
            self.mentionsButtonIndicator.isHidden = true
            self.allButtonIndicator.isHidden = false
        }
        delegate?.tappedAllButton()
    }
    
    @objc private func didTapMentionsButton() {
        UIView.animate(withDuration: 0.2) {
            //animate later
            self.allButtonIndicator.isHidden = true
            self.mentionsButtonIndicator.isHidden = false
        }
        delegate?.tappedMentionsButton()
    }
}
