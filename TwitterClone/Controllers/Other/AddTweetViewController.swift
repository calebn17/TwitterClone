//
//  AddTweetViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/15/22.
//

import UIKit

protocol AddTweetViewControllerDelegate: AnyObject {
    func didTapTweetPublishButton(tweet: TweetModel)
}

final class AddTweetViewController: UIViewController {
//MARK: - Setup
    
    public weak var delegate: AddTweetViewControllerDelegate?
    
    private var tweetBody: String?
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .label
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chooseAudienceButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.layer.borderWidth = 2
        button.setTitle("  Everyone  ", for: .normal)
        button.setTitleColor(.systemCyan, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 13
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tweetTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "What's happening?"
        field.backgroundColor = .systemBackground
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let tweetPublishButton: UIButton = {
        let icon = UIButton()
        icon.backgroundColor = .systemGray
        icon.setTitleColor(.label, for: .disabled)
        icon.setTitle("  Tweet  ", for: .normal)
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 13
        icon.isEnabled = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        addConstraints()
        tweetTextField.becomeFirstResponder()
        tweetTextField.delegate = self
        tweetPublishButton.addTarget(self, action: #selector(tappedTweetPublishButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        chooseAudienceButton.addTarget(self, action: #selector(didTapChooseAudienceButton), for: .touchUpInside)
    }
 
//MARK: - Configure Methods
    
    private func addConstraints() {
        let userImageViewConstraints = [
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            userImageView.widthAnchor.constraint(equalToConstant: K.userImageSize),
            userImageView.heightAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let chooseAudiencebuttonConstraints = [
            chooseAudienceButton.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            chooseAudienceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            chooseAudienceButton.heightAnchor.constraint(equalToConstant: K.userImageSize/1.5)
        ]
        let tweetTextFieldConstraints = [
            tweetTextField.leadingAnchor.constraint(equalTo: chooseAudienceButton.leadingAnchor),
            tweetTextField.topAnchor.constraint(equalTo: chooseAudienceButton.bottomAnchor, constant: 10),
            tweetTextField.widthAnchor.constraint(equalToConstant: 350)
        ]
        let tweetPublishButtonConstraints = [
            tweetPublishButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            tweetPublishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        let cancelButtonConstraints = [
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(chooseAudiencebuttonConstraints)
        NSLayoutConstraint.activate(tweetTextFieldConstraints)
        NSLayoutConstraint.activate(tweetPublishButtonConstraints)
        NSLayoutConstraint.activate(cancelButtonConstraints)
    }
    
    private func addSubViews() {
        view.addSubview(userImageView)
        view.addSubview(chooseAudienceButton)
        view.addSubview(tweetTextField)
        view.addSubview(tweetPublishButton)
        view.addSubview(cancelButton)
    }
    
//MARK: - Action Methods
    
    @objc private func tappedTweetPublishButton() {
        dismiss(animated: true) {[weak self] in
            //passing tweet body through
            self?.tweetBody = self?.tweetTextField.text
            guard let tweetBody = self?.tweetBody else {return}
            
            //Username and handle will be updated in the Home VC
            let addedTweetID = Int.random(in: 0...100)
            let addedTweet = TweetModel(tweetId: addedTweetID, username: nil, userHandle: nil, userAvatar: nil, text: tweetBody, isLikedByUser: false, isRetweetedByUser: false, likes: 0, retweets: 0, comments: nil, dateCreated: Date())
            self?.delegate?.didTapTweetPublishButton(tweet: addedTweet)
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChooseAudienceButton() {
        let actionSheet = UIAlertController(title: "Choose Audience", message: "", preferredStyle: .actionSheet)
        
        //fetch communities and add an action for each
        
        actionSheet.addAction(UIAlertAction(title: "Everyone", style: .default, handler: { _ in
            //Set audience to "Everyone"
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: - TextField Methods

extension AddTweetViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tweetPublishButton.backgroundColor = .systemCyan
        tweetPublishButton.isEnabled = true
        tweetBody = textField.text
        tweetTextField.resignFirstResponder()
        tappedTweetPublishButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            tweetPublishButton.backgroundColor = .systemGray
            tweetPublishButton.isEnabled = false
            return
        }
        tweetPublishButton.backgroundColor = .systemCyan
        tweetPublishButton.isEnabled = true
    }
    
    
    
}
