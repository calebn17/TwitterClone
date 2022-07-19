//
//  RegisterViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/20/22.
//

import UIKit

protocol RegisterViewControllerDelegate: AnyObject {
    func didRegisterSuccessfully()
}

final class RegisterViewController: UIViewController {
    
    weak var delegate: RegisterViewControllerDelegate?

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
    
    private let emailField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "  Enter your email address...  "
        textField.textAlignment = .center
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
    
    private let usernameField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "  Enter your username...  "
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let userHandleField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "  Enter your user handle...  "
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Enter your password...  "
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBackground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(usernameLabel)
        view.addSubview(userHandleField)
    }
    
    private func addConstraints() {
        let size: CGFloat = 200
        
        let usernameLabelConstraints = [
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        ]
        let usernameFieldConstraints = [
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15),
            usernameField.heightAnchor.constraint(equalToConstant: 40),
            usernameField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let userHandleFieldConstraints = [
            userHandleField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userHandleField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            userHandleField.heightAnchor.constraint(equalToConstant: 40),
            userHandleField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let emailLabelConstraints = [
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: userHandleField.bottomAnchor, constant: 30)
        ]
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let passwordLabelConstraints = [
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: size),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(usernameLabelConstraints)
        NSLayoutConstraint.activate(usernameFieldConstraints)
        NSLayoutConstraint.activate(userHandleFieldConstraints)
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordLabelConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
    
    @objc private func didTapRegisterButton() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8,
              let username = usernameField.text, !username.isEmpty,
              let userHandle = userHandleField.text, !userHandle.isEmpty
        else {return}
        
        let newUser = User(
            id: nil,
            userName: username,
            userHandle: userHandle,
            userEmail: email
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
}

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
