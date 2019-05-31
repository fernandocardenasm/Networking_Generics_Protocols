//
//  SignUpViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando on 22.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import CryptoSwift
import Firebase
import UIKit

// TODO: Refacotr this class

class SignUpViewController: UIViewController {
    let loginService: FirebaseLoginService
    weak var coordinator: LoginCoordinator?

    init(loginService: FirebaseLoginService) {
        self.loginService = loginService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        textField.placeholder = "username"
        textField.textAlignment = .center
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        textField.placeholder = "password"
        textField.textAlignment = .center
        return textField
    }()

    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Sign up", for: .normal)

        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let configuration = URLSessionConfiguration.default
        // This value is empiric and given in seconds, the default value given by Apple is 60 seconds
//        configuration.timeoutIntervalForRequest = Constants.timeoutForRequestSeconds
//        configuration.timeoutIntervalForRequest = 10.0
//        let marvelAPI = MarvelAPI(session: URLSession(configuration: configuration))
//        marvelAPI.run()
//        marvelAPI.downloadResponse(for: GetComicCharactersRequest()) { result in
//            switch result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

//        firestore = FirebaseFirestore<Firestore>(database: Firestore.firestore())

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43 / 255.0, green: 43 / 255.0, blue: 45 / 255.0, alpha: 1.0)

        setupUsernameTextField()
        setupPasswordTextField()
        setupSignUpButton()
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

    private func setupSignUpButton() {
        view.addSubview(signUpButton)

        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        [signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         signUpButton.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    @objc func signUpTapped(sender: UIButton) {
        coordinator?.signUp(withUsername: usernameTextField.text ?? "",
                            password: passwordTextField.text ?? "")
    }
}

extension SignUpViewController {
    private struct Constants {
        // This value is empiric, the default value given by Apple is 60 seconds
        let timeoutForRequestSeconds = 10.0
    }
}

struct Product {
    let id: String
    let data: [String: Any]
}
