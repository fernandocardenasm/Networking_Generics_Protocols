//
//  CharactersViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 27.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit
import Firebase

class CharactersViewController: UIViewController {

    var repositoryService: FirebaseRepositoryService!

    private var products: [Product] = []

    init(repositoryService: FirebaseRepositoryService) {
        self.repositoryService = repositoryService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var addCharacterButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Add",
                                   style: .plain,
                                   target: self,
                                   action: #selector(handleAddCharacter))
        return item
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 45/255.0, alpha: 1.0)

        navigationItem.rightBarButtonItem = addCharacterButtonItem

        repositoryService.productsCallback = { products in
            self.products = products
            print("Callback Products")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("These Products: \(products.count)")
    }

    @objc func handleAddCharacter(sender: UIBarButtonItem) {
        print("Button Tapped")
        let viewController = AddCharacterViewController(repositoryService: repositoryService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
