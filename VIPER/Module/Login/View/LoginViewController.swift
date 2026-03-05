//
//  LoginViewController.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import UIKit

final class LoginViewController: BaseViewController<LoginPresenterProtocol> {

    private weak var emailTextField: UITextField?
    private weak var passwordTextField: UITextField?

    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Login"

        let emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.borderStyle = .roundedRect
        emailField.translatesAutoresizingMaskIntoConstraints = false

        let passwordField = UITextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.borderStyle = .roundedRect
        passwordField.translatesAutoresizingMaskIntoConstraints = false

        emailTextField = emailField
        passwordTextField = passwordField

        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)

        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 16),
            passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func loginButtonTapped() {
        guard let email = emailTextField?.text, !email.isEmpty,
              let password = passwordTextField?.text, !password.isEmpty else {
            return
        }
        presenter?.doLogin(email: email, password: password)
    }
}

extension LoginViewController: LoginPresenterDelegate {
    func loginSuccess() {
        let alert = UIAlertController(title: "Success",
                                      message: "Login successful!",
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func loginFailed(error: String) {
        let alert = UIAlertController(title: "Error",
                                      message: error,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
