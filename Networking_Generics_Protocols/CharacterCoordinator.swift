//
//  CharacterCoordinator.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 31.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit

class CharacterCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    let repositoryService: FirebaseRepositoryService
    weak var parentCoordinator: MainCoordinator?

    init(navigationController: UINavigationController,
         repositoryService: FirebaseRepositoryService) {
        self.navigationController = navigationController
        self.repositoryService = repositoryService
    }

    lazy var charactersViewController: CharactersViewController = {
        let viewController = CharactersViewController(characters: repositoryService.products)
        viewController.coordinator = self
        return viewController
    }()

    lazy var addCharacterViewController: AddCharacterViewController = {
        let viewController = AddCharacterViewController()
        viewController.coordinator = self
        return viewController
    }()

    func start() {
        navigationController.pushViewController(charactersViewController, animated: true)
    }

    func startAddCharacter() {
        navigationController.pushViewController(addCharacterViewController, animated: true)
    }

    func addCharacter(withName name: String) {
        repositoryService.addProduct(name: name)
        navigationController.popViewController(animated: true)
    }
}
