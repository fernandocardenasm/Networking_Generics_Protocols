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

    lazy var productsCountTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70/255.0, green: 65/255.0, blue: 63/255.0, alpha: 1.0)
        tf.placeholder = "Product Count"
        tf.textAlignment = .center
        return tf
    }()

    private var products: [Product] = [] {
        didSet {
            print("Were Set")
            productsCountTextField.text = "\(self.products.count)"
        }
    }

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

        view.addSubview(productsCountTextField)
        productsCountTextField.translatesAutoresizingMaskIntoConstraints = false

        [productsCountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
         productsCountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         productsCountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         productsCountTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }

        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 45/255.0, alpha: 1.0)

        navigationItem.rightBarButtonItem = addCharacterButtonItem

        repositoryService.productsCallback = { products in
            self.products = products
            print("Callback Products: \(products.count )")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func handleAddCharacter(sender: UIBarButtonItem) {
        print("Button Tapped")
        let viewController = AddCharacterViewController(repositoryService: repositoryService)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
