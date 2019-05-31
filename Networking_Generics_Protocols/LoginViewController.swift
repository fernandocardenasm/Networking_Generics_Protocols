//
//  LoginViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 29.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    weak var coordinator: LoginCoordinator?

    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        tf.placeholder = "username"
        tf.textAlignment = .center
        return tf
    }()

    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        tf.placeholder = "password"
        tf.textAlignment = .center
        return tf
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Login", for: .normal)

        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()

    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Create new Account", for: .normal)

        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43 / 255.0, green: 43 / 255.0, blue: 45 / 255.0, alpha: 1.0)

        setupUsernameTextField()
        setupPasswordTextField()
        setupLoginButton()
        setupCreateAccountButton()
    }

    private func setupUsernameTextField() {
        view.addSubview(usernameTextField)

        usernameTextField.translatesAutoresizingMaskIntoConstraints = false

        [usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
         usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         usernameTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "login_username")
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = imageView
    }

    private func setupPasswordTextField() {
        view.addSubview(passwordTextField)

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        [passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
         passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         passwordTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "login_password")
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = imageView
    }

    func setupLoginButton() {
        view.addSubview(loginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false

        [loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         loginButton.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    func setupCreateAccountButton() {
        view.addSubview(createAccountButton)

        createAccountButton.translatesAutoresizingMaskIntoConstraints = false

        [createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 30),
         createAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         createAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         createAccountButton.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    @objc func loginTapped(sender: UIButton) {
        coordinator?.login(withUsername: "", password: "")
    }

    @objc func signUpTapped(sender: UIButton) {
        coordinator?.createAccount()
    }
}
