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
    var navigationController: UINavigationController { get }
    func start()
}

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // TODO If user is logggedin, then show the logged In ViewController, otherwise the not logged In.
        let loggedIn = false
        if loggedIn {
            // Show something
        }
        else {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController,
                                                    loginService: FirebaseLoginServiceImpl(database: Firestore.firestore()))
            loginCoordinator.parentCoordinator = self

            childCoordinators.append(loginCoordinator)

            loginCoordinator.start()
        }
    }

    func didFinishSignUp(loginCoordinator: LoginCoordinator) {
        childDidFinish(loginCoordinator)

        let charactersCoordinator = CharacterCoordinator(navigationController: navigationController, repositoryService: FirebaseRepositoryServiceImpl(database: Firestore.firestore()))
        charactersCoordinator.parentCoordinator = self

        childCoordinators.append(charactersCoordinator)

        charactersCoordinator.start()
    }

    private func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
