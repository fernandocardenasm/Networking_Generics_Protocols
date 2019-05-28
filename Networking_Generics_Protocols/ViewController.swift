//
//  ViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando on 22.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import CryptoSwift
import Firebase
import UIKit

// TODO: Refacotr this class

class ViewController<FB: FBFirestore>: UIViewController {

    var firestore: FirebaseFirestore<FB>!
    var userRef: FB.CollectionRef!
    var usersListener: ListenerRegistration!

    var loginService: FirebaseLoginService!

    init(firestore: FirebaseFirestore<FB>,
         loginService: FirebaseLoginService) {
        self.firestore = firestore
        self.loginService = loginService
//        self.firebaseService = firebaseService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70/255.0, green: 65/255.0, blue: 63/255.0, alpha: 1.0)
        tf.placeholder = "username"
        tf.textAlignment = .center
        return tf
    }()

    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70/255.0, green: 65/255.0, blue: 63/255.0, alpha: 1.0)
        tf.placeholder = "password"
        tf.textAlignment = .center
        return tf
    }()

    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Register", for: .normal)

        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        usersListener = userRef.addSnapshotListener { (collectionSnapshot, error) in
//            guard let collectionSnapshot = collectionSnapshot, !collectionSnapshot.documentChanges.isEmpty  else { return }
//
//            collectionSnapshot.documentChanges.forEach {
//                print($0.document.data())
//                print("--------------")
//            }
//        }
//        createFirstUser()
//        createSecondUser()
    }

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

        userRef = firestore.database.collection("users")

        usersListener = userRef.addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let querySnapshot = querySnapshot {
                guard !querySnapshot.documentChanges.isEmpty else {
                    print("No documents changed")
                    return
                }
                querySnapshot.documentChanges.forEach {
                    print("Document Data: \($0.document.data())")
                }
                print("Changes: \(querySnapshot.documentChanges.count)")
                print("--------------")
            }
        })

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 45/255.0, alpha: 1.0)

        setupUsernameTextField()
        setupPasswordTextField()
        setupRegisterButton()
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

    func setupRegisterButton() {
        view.addSubview(registerButton)

        registerButton.translatesAutoresizingMaskIntoConstraints = false

        [registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         registerButton.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        usersListener.remove()
    }

    @objc func handleRegisterUser(sender: UIButton) {
        loginService.createUser(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }

    func allUsers() {
//        let db = Firestore.firestore()
        firestore.database.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}

struct Product {
    let id: String
    let data: [String: Any]
}

extension ViewController {
    private struct Constants {
        // This value is empiric, the default value given by Apple is 60 seconds
        let timeoutForRequestSeconds = 10.0
    }
}
