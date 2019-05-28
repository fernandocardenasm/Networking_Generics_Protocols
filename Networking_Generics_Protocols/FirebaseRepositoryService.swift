//
//  FirebaseRepositoryService.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 28.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase

protocol FirebaseRepositoryService {
    func addProduct(name: String)

    var productsCallback: (([Product]) -> Void)? { get set }
}

class FirebaseRepositoryServiceImpl<Database: FBFirestore>: FirebaseRepositoryService {

    let database: Database
    private var productsListener: ListenerRegistration?

    var productsCallback: (([Product]) -> Void)?


    init(database: Database) {
        self.database = database

        addProductsListener()
    }

    deinit {
        productsListener?.remove()
    }

    private func addProductsListener() {
        guard productsListener == nil else {
            return
        }
        productsListener = database.collection("products").addSnapshotListener({ [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let querySnapshot = querySnapshot {
                guard !querySnapshot.documentChanges.isEmpty else {
                    print("No documents changed")
                    return
                }
                let products = querySnapshot.documentChanges.map { Product(id: $0.document.documentID,
                                                                           data: $0.document.data()) }

                self?.productsCallback?(products)
                querySnapshot.documentChanges.forEach {
                    print("Document Data: \($0.document.data())")
                }
                print("Changes: \(querySnapshot.documentChanges.count)")
                print("--------------")
                print("Documents: \(querySnapshot.documents.count)")
            }
        })
    }

    func addProduct(name: String) {
        var ref: FBDocumentReference? = nil
        //        let db = Firestore.firestore()
        ref = database.collection("products").addDocument(data: [
            "name": name
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref?.documentID ?? "Emtpy Id")")
            }
        }
    }
}
