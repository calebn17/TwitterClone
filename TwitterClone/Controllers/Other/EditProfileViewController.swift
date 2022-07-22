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
        view.addSubview(textView)
        textView.delegate = self
        
        view.addSubview(saveButton)
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        
        saveButton.sizeToFit()
        saveButton.frame = CGRect(x: view.width - 150, y: view.bottom - 200, width: saveButton.width, height: saveButton.height)
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == K.textViewPlaceholder {
            textView.text = nil
        }
    }
}
