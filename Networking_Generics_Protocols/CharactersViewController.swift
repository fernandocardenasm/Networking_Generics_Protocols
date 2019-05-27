//
//  CharactersViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 27.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController {

    var characters: [String] = [""] {
        didSet{
            print("Did set")
        }
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

        navigationItem.rightBarButtonItem = addCharacterButtonItem
    }

    @objc func handleAddCharacter(sender: UIBarButtonItem) {
        print("Button Tapped")
        navigationController?.pushViewController(AddCharacterViewController(), animated: true)
    }
}
