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

    deinit {
        print("Deinit of LoginCoordinator")
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

    func startCreateAccount() {
        navigationController.pushViewController(signUpViewController, animated: true)
    }

    func signIn(withEmail email: String, password: String) {
        loginService.signIn(withEmail: email, password: password) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let documentId):
                print("Sign In Success: \(documentId)")
                strongSelf.parentCoordinator?.didFinishSignIn(loginCoordinator: strongSelf)
            case .failure(let error):
                print("Error Sign In: \(error.localizedDescription)")
                let alert = strongSelf.makeAlert(title: "Sign In",
                                                 message: "An error occurs while signging in. Please try it again.")
                strongSelf.loginViewController.present(alert, animated: true)
            }
        }
    }

    func signUp(withEmail email: String, password: String) {
        // Do something with the sign up.
        loginService.createUser(withEmail: email,
                                password: password) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let documentId):
                print("Sign Up Success: \(documentId)")
                strongSelf.parentCoordinator?.didFinishSignUp(loginCoordinator: strongSelf)
            case .failure(let error):
                print("Error Sign Up: \(error.localizedDescription)")
                let alert = strongSelf.makeAlert(title: "Sign Up",
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
