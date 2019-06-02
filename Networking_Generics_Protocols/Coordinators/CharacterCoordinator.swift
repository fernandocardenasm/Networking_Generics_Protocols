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

    // Button Items
    lazy var addCharacterButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add",
                                   style: .plain,
                                   target: self,
                                   action: #selector(addCharacterTapped))
        return item
    }()
    
    lazy var saveCharacterButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save",
                                   style: .plain,
                                   target: self,
                                   action: #selector(saveCharacterTapped))
        return item
    }()

    func start() {
        navigationController.setViewControllers([charactersViewController], animated: true)
    }
}

// MARK: - ButtonItems

extension CharacterCoordinator {
    @objc func addCharacterTapped(sender: UIBarButtonItem) {
        navigationController.navigationItem.rightBarButtonItem = saveCharacterButtonItem
        navigationController.pushViewController(addCharacterViewController, animated: true)
    }

    @objc func saveCharacterTapped(sender: UIBarButtonItem) {
        print("Save Button Tapped")
        repositoryService.addProduct(name: addCharacterViewController.nameTextField.text ?? "")
        navigationController.popViewController(animated: true)
    }
}
