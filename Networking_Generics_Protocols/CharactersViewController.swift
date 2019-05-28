//
//  CharactersViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 27.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase
import RxSwift
import UIKit

class CharactersViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var repositoryService: FirebaseRepositoryService!

    var charactersCollectionView: UICollectionView!

    let disposeBag = DisposeBag()

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

        view.backgroundColor = UIColor(red: 43 / 255.0, green: 43 / 255.0, blue: 45 / 255.0, alpha: 1.0)

        navigationItem.rightBarButtonItem = addCharacterButtonItem

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 100, height: 100)

        charactersCollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        charactersCollectionView.dataSource = self
        charactersCollectionView.delegate = self
        charactersCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        charactersCollectionView.showsVerticalScrollIndicator = false
        charactersCollectionView.backgroundColor = .white
        self.view.addSubview(charactersCollectionView)

        repositoryService.products.subscribe(onNext: { (products) in
            print("These was called")
            self.charactersCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @objc func handleAddCharacter(sender: UIBarButtonItem) {
        print("Button Tapped")
        let viewController = AddCharacterViewController(repositoryService: repositoryService)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositoryService.products.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = charactersCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CharacterCollectionViewCell

        cell.nameLabel.text = repositoryService.products.value[indexPath.item].id
        return cell
    }
}

class CharacterCollectionViewCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "To be set..."
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 70 / 255.0, green: 65 / 255.0, blue: 63 / 255.0, alpha: 1.0)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        [nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
         nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
         nameLabel.heightAnchor.constraint(equalToConstant: 100),
         nameLabel.widthAnchor.constraint(equalToConstant: 100)].forEach { $0.isActive = true }
    }
}
