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


//MARK: - SubViews
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailField: ReusableTextField = {
        let textField = ReusableTextField()
        textField.placeholder = "  Enter your email address...  "
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameField: ReusableTextField = {
        let textField = ReusableTextField()
        textField.placeholder = "  Enter your username...  "
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let userHandleField: ReusableTextField = {
        let textField = ReusableTextField()
        textField.placeholder = "  Enter your user handle...  "
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: ReusableTextField = {
        let textField = ReusableTextField()
        textField.placeholder = "  Enter your password...  "
        textField.textAlignment = .left
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
        addSubviews()
        addConstraints()
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(userHandleField)
    }
    
//MARK: - Actions
    @objc private func didTapRegisterButton() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 4,
              let username = usernameField.text,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              let userHandle = userHandleField.text,
              !userHandle.trimmingCharacters(in: .whitespaces).isEmpty
        else {return}
        
        let newUser = User(
            id: nil,
            userName: username,
            userHandle: userHandle.lowercased(),
            userEmail: email.lowercased()
        )
            
        AuthManager.shared.registerNewUser(newUser: newUser, password: password) {[weak self] registered in
            DispatchQueue.main.async {
                if registered {
                    self?.dismiss(animated: true)
                    self?.delegate?.didRegisterSuccessfully()
                }
                else {
                    //something failed
                    print("failed to register")
                }
            }
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
}

//MARK: - SubView Constraints
extension RegisterViewController {
    
    private func addConstraints() {
        let size: CGFloat = 200
        
        let usernameFieldConstraints = [
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
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
        NSLayoutConstraint.activate(usernameFieldConstraints)
        NSLayoutConstraint.activate(userHandleFieldConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
