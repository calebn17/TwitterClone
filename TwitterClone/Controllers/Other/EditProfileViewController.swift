//
//  EditProfileViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    struct K {
        static let textViewPlaceholder = "Add your bio..."
    }
    
    private let textView: UITextView = {
        let view = UITextView()
        view.text = K.textViewPlaceholder
        view.backgroundColor = .secondarySystemBackground
        view.textContainerInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save Changes", for: .normal)
        button.backgroundColor = .link
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        addSubViews()
        textView.delegate = self
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = CGRect(x: 20, y: 300, width: view.width - 40, height: 100)
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: (view.width - saveButton.width - 20)/2, y: view.bottom - 200, width: saveButton.width + 20, height: saveButton.height)
    }
    
    private func addSubViews() {
        view.addSubview(textView)
        view.addSubview(saveButton)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapSaveButton() {
        didTapCloseButton()
        guard let bio = textView.text,
              !textView.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        ProfileHeaderViewModel.setProfileBio(bio: bio)
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == K.textViewPlaceholder {
            textView.text = nil
        }
    }
}
