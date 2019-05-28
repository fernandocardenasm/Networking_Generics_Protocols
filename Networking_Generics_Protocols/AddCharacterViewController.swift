//
//  AddCharacterViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 27.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit

class AddCharacterViewController: UIViewController {
    let repositoryService: FirebaseRepositoryService

    init(repositoryService: FirebaseRepositoryService) {
        self.repositoryService = repositoryService

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var addCharacterButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save",
                                   style: .plain,
                                   target: self,
                                   action: #selector(handleAddCharacter))
        return item
    }()

    lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        tf.placeholder = "Write name..."
        tf.textAlignment = .center
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43 / 255.0, green: 43 / 255.0, blue: 45 / 255.0, alpha: 1.0)

        navigationItem.rightBarButtonItem = addCharacterButtonItem

        setupNameTextField()
    }

    private func setupNameTextField() {
        view.addSubview(nameTextField)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false

        [nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
         nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         nameTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    @objc func handleAddCharacter(sender: UIBarButtonItem) {
        print("Save Button Tapped")
        repositoryService.addProduct(name: nameTextField.text ?? "")
    }
}
