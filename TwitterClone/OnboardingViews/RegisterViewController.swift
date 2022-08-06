//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/20/22.
//

import UIKit

//MARK: - Protocol
protocol RegisterViewControllerDelegate: AnyObject {
    func didRegisterSuccessfully()
}

final class RegisterViewController: UIViewController {

//MARK: - Properties
    weak var delegate: RegisterViewControllerDelegate?
    private var image: UIImage?
    weak var coordinator: RegisterCoordinator?


//MARK: - SubViews
    private let profileImageView: CustomImageView = {
        let imageView = CustomImageView(frame: .zero)
        imageView.layer.cornerRadius = K.userImageSize*1.5/2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let emailLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "Email Address"
        label.numberOfLines = 1
        return label
    }()
    
    private let emailField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your email address...  "
        return textField
    }()
    
    private let usernameField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your username...  "
        return textField
    }()
    
    private let userHandleField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your user handle...  "
        return textField
    }()
    
    private let passwordField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your password...  "
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let registerButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Register", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        return button
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        addSubviews()
        addConstraints()
        configureTextFields()
        addActions()
    }
    
    private func addSubviews() {
        view.addSubview(profileImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(userHandleField)
    }
    
    private func addActions() {
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap2)
    }
    
//MARK: - Configure
    private func configureTextFields() {
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        userHandleField.delegate = self
    }
    
//MARK: - Actions
    @objc private func didTapProfileImage() {
        coordinator?.tappedOnProfileImage(sender: self)
    }
    
    @objc private func didTapRegisterButton() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@"), email.contains("."),
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 4,
              let username = usernameField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              let userHandle = userHandleField.text,
              !userHandle.trimmingCharacters(in: .whitespaces).isEmpty,
              let image = self.image
        else {return}
        
        let newUser = User(
            id: nil,
            userName: username,
            userHandle: userHandle.lowercased(),
            userEmail: email.lowercased()
        )
        Task {
            try await OnboardingViewModel.registerNewUser(user: newUser, password: password, data: image.pngData())
            self.coordinator?.registerSuccessfully(sender: self)
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextField Methods
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            userHandleField.becomeFirstResponder()
        }
        else if textField == userHandleField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegisterButton()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

//MARK: - Image Picker Methods
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.image = image
        profileImageView.image = image
    }
}

//MARK: - SubView Constraints
extension RegisterViewController {
    
    private func addConstraints() {
        let size: CGFloat = 200
        
        let profileImageViewConstraints = [
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: K.userImageSize*1.5),
            profileImageView.widthAnchor.constraint(equalToConstant: K.userImageSize*1.5)
        ]
        let usernameFieldConstraints = [
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            usernameField.heightAnchor.constraint(equalToConstant: 40),
            usernameField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let userHandleFieldConstraints = [
            userHandleField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userHandleField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            userHandleField.heightAnchor.constraint(equalToConstant: 40),
            userHandleField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: userHandleField.bottomAnchor, constant: 20),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: size),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(usernameFieldConstraints)
        NSLayoutConstraint.activate(userHandleFieldConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
