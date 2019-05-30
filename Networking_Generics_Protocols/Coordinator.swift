//
//  Coordinator.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 30.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // TODO If user is logggedin, then use the loginCoordinator, otherwise show another controller
        let viewController = LoginViewController(loginService: FirebaseLoginServiceImpl(database: Firestore.firestore()))
        viewController.coordinator = self

        navigationController.pushViewController(viewController, animated: true)
    }
}
