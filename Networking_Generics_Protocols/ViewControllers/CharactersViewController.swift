//
//  CharactersViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 27.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase
import RxCocoa
import RxSwift
import UIKit

class CharactersViewController: UIViewController {
    let characters: BehaviorRelay<[Product]>
    let disposeBag = DisposeBag()
    weak var coordinator: CharacterCoordinator?

    init(characters: BehaviorRelay<[Product]>) {
        self.characters = characters

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43 / 255.0, green: 43 / 255.0, blue: 45 / 255.0, alpha: 1.0)

        setupCollectionView()
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)

        setupCollectionViewConstraints()
        setupCollectionViewProperties()
    }

    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        [collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 10),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: -10),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -10),
         collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                constant: -10)].forEach { $0.isActive = true }
    }

    private func setupCollectionViewProperties() {
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellId)
        collectionView.alwaysBounceVertical = true
    }

    func setupBindings() {
        characters.subscribe(onNext: { [weak self] _ in
            self?.collectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId,
                                                            for: indexPath) as? CharacterCollectionViewCell else {
            return CharacterCollectionViewCell()
        }

        cell.nameLabel.text = characters.value[indexPath.item].id
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

extension CharactersViewController {
    private struct Constants {
        static let cellId = "cellId"
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
