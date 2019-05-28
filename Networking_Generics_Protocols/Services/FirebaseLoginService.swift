//
//  FirebaseLoginService.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 28.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Firebase

protocol FirebaseLoginService {
    func createUser(username: String, password: String)
}

class FirebaseLoginServiceImpl<Database: FBFirestore>: FirebaseLoginService {

    let database: Database

    init(database: Database) {
        self.database = database
    }

    func createUser(username: String, password: String) {
        var ref: FBDocumentReference? = nil
        //        let db = Firestore.firestore()
        ref = database.collection("users").addDocument(data: [
            "username": username,
            "password": password
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref?.documentID ?? "Emtpy Id")")
            }
        }
    }
}
