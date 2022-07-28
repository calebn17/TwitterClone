//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/20/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    
//MARK: - Subviews
    
    private let logo: CustomImageView = {
        let logo = CustomImageView(frame: .zero)
        logo.image = UIImage(named: "twitterLogo2")
        logo.backgroundColor = .systemBackground
        return logo
    }()
    
    private let emailField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your email address...  "
        textField.textAlignment = .left
        textField.returnKeyType = .next
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let passwordField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "  Enter your password...  "
        textField.textAlignment = .left
        textField.isSecureTextEntry = true
        textField.keyboardType = .default
        textField.returnKeyType = .done
        return textField
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Login", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.secondaryLabel.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let registerButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Don't have an account? Register here!", for: UIControl.State.normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderColor = UIColor.systemBackground.cgColor
        return button
    }()
    
//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        addSubviews()
        addConstraints()
        configureTextFields()
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    private func addSubviews() {
        view.addSubview(logo)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
//MARK: - Configure
    private func configureTextFields() {
        emailField.delegate = self
        passwordField.delegate = self
    }
 
//MARK: - Actions
    
    @objc private func didTapLoginButton(){
        
        //dissmiss the keyboard. making sure both fields are not focused on with the cursor
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        
        guard let email = emailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              email.contains("@"),
              email.contains("."),
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 4 else {return}
        
        //login functionality
        AuthManager.shared.loginUser(email: email.lowercased(), password: password) {[weak self] success in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                if success {
                    self?.coordinator?.successfulLogin(sender: strongSelf)
                }
                else {
                    //error occured
                    self?.coordinator?.presentLoginErrorAlert(sender: strongSelf)
                    AuthManager.shared.logOut { success in
                        if !success {
                            print("couldnt log out")
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didTapRegisterButton() {
        coordinator?.tappedOnRegisterButton(sender: self)
    }
}

//MARK: - TextField Methods

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            //puts the password field in focus when the user hits 'Return'
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
}

extension LoginViewController: RegisterViewControllerDelegate {
    func didRegisterSuccessfully() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Configure Methods
extension LoginViewController {
    private func addConstraints() {
        let size: CGFloat = 200
        
        let logoConstraints = [
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            logo.widthAnchor.constraint(equalToConstant: 200),
            logo.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let emailFieldConstraints = [
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            emailField.heightAnchor.constraint(equalToConstant: 40),
            emailField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let passwordFieldConstraints = [
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            passwordField.widthAnchor.constraint(equalToConstant: 300)
        ]
        let loginButtonConstraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: size),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        let registerButtonConstraints = [
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 60),
            registerButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(logoConstraints)
        NSLayoutConstraint.activate(emailFieldConstraints)
        NSLayoutConstraint.activate(passwordFieldConstraints)
        NSLayoutConstraint.activate(loginButtonConstraints)
        NSLayoutConstraint.activate(registerButtonConstraints)
    }
}
