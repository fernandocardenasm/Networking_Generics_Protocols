//
//  FirebaseRepositoryService.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 28.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//
// import FirebaseFirestore to get access tot the protocol ListenerRegistration
import FirebaseFirestore
import RxCocoa

protocol FirebaseRepositoryService {
    func addProduct(name: String)
    
    var products: BehaviorRelay<[Product]> { get }
}

class FirebaseRepositoryServiceImpl<Database: FBFirestore>: FirebaseRepositoryService {
    let database: Database
    private var productsListener: ListenerRegistration?
    var products = BehaviorRelay<[Product]>(value: [])

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
        productsListener = database.collection("products").addSnapshotListener({ [weak self] querySnapshot, error in
            if let error = error {
                print("Error: \(error)")
            } else if let querySnapshot = querySnapshot {
                guard !querySnapshot.documentChanges.isEmpty else {
                    print("No documents changed")
                    return
                }
                let products = querySnapshot.documents.map { Product(id: $0.documentID,
                                                                     data: $0.data()) }

                self?.products.accept(products)

                querySnapshot.documentChanges.forEach {
                    print("Document Data: \($0.document.data())")
                }
                print("Changes: \(querySnapshot.documentChanges.count)")
                print("--------------")
                print("Documents: \(querySnapshot.documents.count)")
            }
            // TO-DO: Add case for else
        })
    }

    func addProduct(name: String) {
        var ref: FBDocumentReference?
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
