//
//  AddCommentViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/15/22.
//

import UIKit

protocol AddCommentViewControllerDelegate: AnyObject {
    func didTapReplyButton(tweetBody: String)
}

final class AddCommentViewController: UIViewController {
    
//MARK: - Setup
    
    public weak var delegate: AddCommentViewControllerDelegate?
    
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
    
    private let tweetTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Tweet your reply"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let replyButton: UIButton = {
        let icon = UIButton()
        icon.backgroundColor = .systemGray
        icon.setTitleColor(.label, for: .disabled)
        icon.setTitle("  Reply  ", for: .normal)
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
        tweetTextField.delegate = self
        tweetTextField.becomeFirstResponder()
        replyButton.addTarget(self, action: #selector(tappedReplyButton), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
//MARK: - Configure Methods
    
    private func addConstraints() {
        let userImageViewConstraints = [
            userImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            userImageView.widthAnchor.constraint(equalToConstant: K.userImageSize),
            userImageView.heightAnchor.constraint(equalToConstant: K.userImageSize)
        ]
        let tweetTextFieldConstraints = [
            tweetTextField.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            tweetTextField.topAnchor.constraint(equalTo: userImageView.topAnchor, constant: 10)
        ]
        let replyButtonConstraints = [
            replyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            replyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        let cancelButtonConstraints = [
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        
        NSLayoutConstraint.activate(userImageViewConstraints)
        NSLayoutConstraint.activate(tweetTextFieldConstraints)
        NSLayoutConstraint.activate(replyButtonConstraints)
        NSLayoutConstraint.activate(cancelButtonConstraints)
    }
    
    private func addSubViews() {
        view.addSubview(userImageView)
        view.addSubview(tweetTextField)
        view.addSubview(replyButton)
        view.addSubview(cancelButton)
    }

//MARK: - Action Methods
    
    @objc private func tappedReplyButton() {
        dismiss(animated: true) {[weak self] in
            //passing tweet body through
            guard let tweetBody = self?.tweetBody else {return}
            self?.delegate?.didTapReplyButton(tweetBody: tweetBody)
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
extension AddCommentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        replyButton.backgroundColor = .systemCyan
        replyButton.isEnabled = true
        tweetBody = textField.text
        tweetTextField.resignFirstResponder()
        tappedReplyButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            replyButton.backgroundColor = .systemGray
            replyButton.isEnabled = false
            return
        }
        replyButton.backgroundColor = .systemCyan
        replyButton.isEnabled = true
        tweetBody = textField.text
    }
}
