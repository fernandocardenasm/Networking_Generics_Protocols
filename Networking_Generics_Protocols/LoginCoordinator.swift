//
//  LoginCoordinator.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 30.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit
import Firebase

class LoginCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let loginService: FirebaseLoginService


    init(navigationController: UINavigationController,
         loginService: FirebaseLoginService) {
        self.navigationController = navigationController
        self.loginService = loginService
    }

    func start() {
        startLogin()
    }

    func startLogin() {
        let viewController = LoginViewController()
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func login(withUsername: String, password: String) {
        // TODO: Login User
    }

    func createAccount() {
        let viewController = SignUpViewController(loginService: FirebaseLoginServiceImpl(database: Firestore.firestore()))
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func signUp(withUsername username: String, password: String) {
        // Do something with the sign up.
        loginService.createUser(username: username, password: password)
        // If successfull, inform parent, otherwise maybe try again.
        parentCoordinator?.didFinishSignUp(loginCoordinator: self)
    }
}
