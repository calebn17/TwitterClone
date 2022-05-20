//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/20/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
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
        textField.placeholder = "Enter your email address..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your password..."
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Login"
        button.tintColor = .label
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Register"
        button.tintColor = .label
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        addConstraints()

      
    }
    
    private func addSubviews() {
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func addConstraints() {
        let size: CGFloat = 100
        let emailLabelConstraints = [
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        ]
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15)
        ]
        let passwordLabelConstraints = [
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15)
        ]
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: size)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -30),
            registerButton.widthAnchor.constraint(equalToConstant: size)
        ]
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordLabelConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
   
}
