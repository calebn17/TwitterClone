//
//  EditProfileViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 7/21/22.
//

import UIKit

//MARK: - Protocol
protocol EditProfileViewControllerDelegate: AnyObject {
    func tappedSaveButton(bio: String)
}

class EditProfileViewController: UIViewController {

//MARK: - Properties
    weak var delegate: EditProfileViewControllerDelegate?
    
    struct K {
        static let textViewPlaceholder = "Add your bio..."
    }
    
//MARK: - SubViews
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

//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        addSubViews()
        textView.delegate = self
        textView.addDoneButton(title: "Done", target: self, selector: #selector(didTapDone))
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.frame = CGRect(x: 20, y: 300, width: view.width - 40, height: 100)
    }
    
    private func addSubViews() {
        view.addSubview(textView)
        view.addSubview(saveButton)
    }
    
//MARK: - Configure
    
    private func configureNavbar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
//MARK: - Actions
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDone() {
        textView.endEditing(true)
    }
    
    @objc private func didTapSaveButton() {
        didTapCloseButton()
        guard let bio = textView.text,
              !textView.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        delegate?.tappedSaveButton(bio: bio)
    }
}

//MARK: - TextView Methods
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == K.textViewPlaceholder {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
