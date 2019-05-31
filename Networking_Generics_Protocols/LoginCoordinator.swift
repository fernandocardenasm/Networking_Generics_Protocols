//
//  LoginCoordinator.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 30.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase
import UIKit

class LoginCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let loginService: FirebaseLoginService
    weak var parentCoordinator: MainCoordinator?

    init(navigationController: UINavigationController,
         loginService: FirebaseLoginService) {
        self.navigationController = navigationController
        self.loginService = loginService
    }

    lazy var loginViewController: LoginViewController = {
        let viewController = LoginViewController()
        viewController.coordinator = self

        return viewController
    }()

    lazy var signUpViewController: SignUpViewController = {
        let viewController = SignUpViewController()
        viewController.coordinator = self

        return viewController
    }()

    func start() {
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func login(withUsername: String, password: String) {
        // TODO: Login User
    }

    func createAccount() {
        navigationController.pushViewController(signUpViewController, animated: true)
    }

    func signUp(withUsername username: String, password: String) {
        // Do something with the sign up.
        loginService.createUser(withUsername: username,
                                password: password) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let documentId):
                print("Success: \(documentId)")
                strongSelf.parentCoordinator?.didFinishSignUp(loginCoordinator: strongSelf)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                let alert = strongSelf.makeAlert(title: "Title",
                                                 message: "An error occurs while creating the account. Please try it again.")
                strongSelf.signUpViewController.present(alert, animated: true)
            }
        }
    }

    func makeAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .cancel) { (_: UIAlertAction) in
            print("Ok")
        }
        alert.addAction(action)

        return alert
    }
}
