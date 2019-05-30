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
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        login()
    }

    func login() {
        let viewController = LoginViewController(loginService: FirebaseLoginServiceImpl(database: Firestore.firestore()))
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }

    func register() {
        let viewController = RegisterUserViewController(loginService: FirebaseLoginServiceImpl(database: Firestore.firestore()))
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }
}
