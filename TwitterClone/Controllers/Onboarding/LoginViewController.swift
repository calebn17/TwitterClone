//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/20/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
//MARK: - Setup
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Address or Username"
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
    
    private let usernameEmailField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "  Enter your email address or username...  "
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  Enter your password...  "
        textField.textAlignment = .left
        textField.layer.borderColor = UIColor.label.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Register here!"
        label.numberOfLines = 1
        label.tintColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//MARK: - View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        addSubviews()
        addConstraints()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(registerLabel)
    }
 
//MARK: - Configure Methods
    
    private func addConstraints() {
        let size: CGFloat = 200
        let emailLabelConstraints = [
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        ]
        let emailFieldConstraints = [
            usernameEmailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameEmailField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            usernameEmailField.heightAnchor.constraint(equalToConstant: 40),
            usernameEmailField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let passwordLabelConstraints = [
            passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordLabel.topAnchor.constraint(equalTo: usernameEmailField.bottomAnchor, constant: 30)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: size),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let registerLabelConstraints = [
            registerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 60)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: registerLabel.bottomAnchor, constant: 20),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.widthAnchor.constraint(equalToConstant: size),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(emailLabelConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordLabelConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerLabelConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
  
//MARK: - Action Methods
    
    @objc private func didTapLoginButton(){
        
        //dissmiss the keyboard. making sure both fields are not focused on with the cursor
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let usernameEmail = usernameEmailField.text, !usernameEmail.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              password.count >= 8 else {return}
        
        //login functionality
        var username: String?
        var email: String?
        
        if usernameEmail.contains("@"), usernameEmail.contains(".") {
            email = usernameEmail
        } else {
            username = usernameEmail
        }
        
        AuthManager.shared.loginUser(username: username, email: email, password: password) {[weak self] success in
            DispatchQueue.main.async {
                if success {
                    //user logged in
                    //dismisses the LoginVC so the HomeVC will be shown
                    self?.dismiss(animated: true, completion: nil)
                }
                else {
                    //error occured
                    let alert = UIAlertController(title: "Log In Error", message: "We were unable to log you in.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func didTapRegisterButton() {
        let vc = RegisterViewController()
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - TextField Methods

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            //puts the password field in focus when the user hits 'Return'
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton()
        }
        
        return true
    }
}
