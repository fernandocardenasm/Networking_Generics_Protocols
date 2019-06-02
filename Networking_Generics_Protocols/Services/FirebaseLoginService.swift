//
//  FirebaseLoginService.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 28.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

protocol FirebaseLoginService {
    func createUser(withEmail: String, password: String, completion: @escaping (Result<String, Error>) -> Void)

    func signIn(withEmail: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
}

class FirebaseLoginServiceImpl<Authentication: FBAuth>: FirebaseLoginService {
    let auth: Authentication

    init(auth: Authentication) {
        self.auth = auth
    }

    func createUser(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let dataResult = authDataResult {
                completion(.success("Result create user"))
            }
            else {
                print("This is an unknown error for createUser")
            }
        }
    }

    func signIn(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                completion(.failure(error))
            }
            else if let dataResult = authDataResult {
                completion(.success("Result sign in user"))
            }
            else {
                print("This is an unknown error for sign in")
            }
        }
    }
}
