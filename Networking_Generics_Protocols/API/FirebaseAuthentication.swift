//
//  FirebaseAuthentication.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 02.06.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import FirebaseAuth

protocol FBAuth {
    associatedtype EndUser: FBUser
    associatedtype DataResult: FBAuthDataResult

    var currentUser: EndUser? { get }

    func createUser(withEmail email: String, password: String, completion: ((DataResult?, Error?) -> Void)?)
}

extension Auth: FBAuth {}

protocol FBUser {
    var isAnonymous: Bool { get }
}

extension User: FBUser {}

protocol FBAuthDataResult {
    associatedtype EndUser: FBUser
    var user: EndUser { get }
}

extension AuthDataResult: FBAuthDataResult {}
