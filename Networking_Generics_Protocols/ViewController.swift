//
//  ViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando on 22.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import CryptoSwift
import Firebase
import UIKit

class ViewController<FB: FBFirestore>: UIViewController {

    var firestore: FirebaseFirestore<FB>!
    var userRef: FB.CollectionRef!
    var usersListener: ListenerRegistration!

    var loginService: FirebaseLoginService!

    init(firestore: FirebaseFirestore<FB>,
         loginService: FirebaseLoginService) {
        self.firestore = firestore
        self.loginService = loginService
//        self.firebaseService = firebaseService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70/255.0, green: 65/255.0, blue: 63/255.0, alpha: 1.0)
        tf.placeholder = "username"
        tf.textAlignment = .center
        return tf
    }()

    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(red: 70/255.0, green: 65/255.0, blue: 63/255.0, alpha: 1.0)
        tf.placeholder = "password"
        tf.textAlignment = .center
        return tf
    }()

    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Register", for: .normal)

        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        usersListener = userRef.addSnapshotListener { (collectionSnapshot, error) in
//            guard let collectionSnapshot = collectionSnapshot, !collectionSnapshot.documentChanges.isEmpty  else { return }
//
//            collectionSnapshot.documentChanges.forEach {
//                print($0.document.data())
//                print("--------------")
//            }
//        }
//        createFirstUser()
//        createSecondUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let configuration = URLSessionConfiguration.default
        // This value is empiric and given in seconds, the default value given by Apple is 60 seconds
//        configuration.timeoutIntervalForRequest = Constants.timeoutForRequestSeconds
//        configuration.timeoutIntervalForRequest = 10.0
//        let marvelAPI = MarvelAPI(session: URLSession(configuration: configuration))
//        marvelAPI.run()
//        marvelAPI.downloadResponse(for: GetComicCharactersRequest()) { result in
//            switch result {
//            case .success(let data):
//                print(data)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

//        firestore = FirebaseFirestore<Firestore>(database: Firestore.firestore())

        userRef = firestore.database.collection("users")

        usersListener = userRef.addSnapshotListener({ (querySnapshot, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let querySnapshot = querySnapshot {
                guard !querySnapshot.documentChanges.isEmpty else {
                    print("No documents changed")
                    return
                }
                querySnapshot.documentChanges.forEach {
                    print("Document Data: \($0.document.data())")
                }
                print("Changes: \(querySnapshot.documentChanges.count)")
                print("--------------")
            }
        })

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 43/255.0, green: 43/255.0, blue: 45/255.0, alpha: 1.0)

        setupUsernameTextField()
        setupPasswordTextField()
        setupRegisterButton()
    }

    private func setupUsernameTextField() {
        view.addSubview(usernameTextField)

        usernameTextField.translatesAutoresizingMaskIntoConstraints = false

        [usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
         usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         usernameTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "login_username")
        usernameTextField.leftViewMode = .always
        usernameTextField.leftView = imageView
    }

    private func setupPasswordTextField() {
        view.addSubview(passwordTextField)

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        [passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
         passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         passwordTextField.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image = UIImage(named: "login_password")
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = imageView
    }

    func setupRegisterButton() {
        view.addSubview(registerButton)

        registerButton.translatesAutoresizingMaskIntoConstraints = false

        [registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
         registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
         registerButton.heightAnchor.constraint(equalToConstant: 50)].forEach { $0.isActive = true }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

        usersListener.remove()
    }

    @objc func handleRegisterUser(sender: UIButton) {
        loginService.createUser(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
    }

    func allUsers() {
//        let db = Firestore.firestore()
        firestore.database.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}

protocol FirebaseLoginService {
    func createUser(username: String, password: String)

    func allUsers()
}

class FirebaseServiceImpl<Database: FBFirestore>: FirebaseLoginService {

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

    func allUsers() {
    }
}

protocol FirebaseRepositoryService {
    func addProduct(name: String)
}

class FirebaseRepositoryServiceImpl<Database: FBFirestore>: FirebaseRepositoryService {

    let database: Database

    init(database: Database) {
        self.database = database
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

class FirebaseFirestore<F: FBFirestore> {
    let database: F

    init(database: F) {
        self.database = database
    }
}

protocol FBFirestore {
    associatedtype CollectionRef: FBCollectionReference & FBQuery
    func collection(_ collectionPath: String) -> CollectionRef
}

extension Firestore: FBFirestore {}

protocol FBCollectionReference {
    associatedtype DocumentRef: FBDocumentReference

    var collectionID: String { get }

    func document() -> DocumentRef

    func addDocument(data: [String: Any]) -> DocumentRef

    func addDocument(data: [String: Any], completion: ((Error?) -> Void)?) -> DocumentRef

    // TODO: The protocol that conforms to this one, may also need to implement FBQuery because CollectionReference is a subclass of FBQuery
}

extension CollectionReference: FBCollectionReference {}

protocol FBDocumentReference {
    var documentID: String { get }
}

extension DocumentReference: FBDocumentReference {}

protocol FBQuery {
    associatedtype Database: FBFirestore
    // Query Snapshot
    associatedtype Snapshot: FBQuerySnapshot

    var firestore: Database { get }

    func getDocuments(completion: @escaping (Snapshot?, Error?) -> Void)

    // ListenerRegistration is already a protocol. For that reason, nonextra associatedType is needed.
    func addSnapshotListener(_ listener: @escaping (Snapshot?, Error?) -> Void) -> ListenerRegistration
}

extension Query: FBQuery { }

protocol FBQuerySnapshot {
    associatedtype QueryDocSnapshot: FBQueryDocumentSnapshot
    associatedtype DocChange: FBDocumentChange

    var documents: [QueryDocSnapshot] { get }

    var documentChanges: [DocChange] { get }

    var isEmpty: Bool { get }

    var count: Int { get }
}

extension QuerySnapshot: FBQuerySnapshot {}

protocol FBQueryDocumentSnapshot {
    var documentID: String { get }

    func data() -> [String: Any]
}

extension QueryDocumentSnapshot: FBQueryDocumentSnapshot {}

protocol FBDocumentChange {
    associatedtype QueryDocSnapshot: FBQueryDocumentSnapshot

    var document: QueryDocSnapshot { get }
}

extension DocumentChange: FBDocumentChange {}

extension ViewController {
    private struct Constants {
        // This value is empiric, the default value given by Apple is 60 seconds
        let timeoutForRequestSeconds = 10.0
    }
}

// This protocol may not be neccessary
// protocol API {
//    associatedtype S: Session
//
//    var session: S { get }
//
//    func run()
// }

class MarvelAPI<S: Session> {
    let session: S

    init(session: S) {
        self.session = session
    }

    func run() {
        guard let url = URL(string: "www.apple.com") else {
            return
        }

        let task = session.dataTask(with: url) { _, _, _ in
        }
        task.resume()
    }

    func downloadResponse<R: APIRequest>(for request: R, completion: @escaping (Result<R.Response, Error>) -> Void) {
        let endpointURL = makeEndpointURL(for: request)

        guard let url = endpointURL else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print(error)
                completion(.failure(error))
            }
            else if let data = data {
                guard let convertedData = self?.convertData(data, for: request) else {
                    completion(.failure(APIError.conversionDataFailed))
                    return
                }
                completion(.success(convertedData))
            }
            else {
                completion(.failure(APIError.unknown))
            }
        }
        task.resume()
    }

    func convertData<R: APIRequest>(_ data: Data, for request: R) -> R.Response? {
        guard let marvelResponse = try? JSONDecoder().decode(MarvelResponse<R.Response>.self,
                                                             from: data),
            let results = marvelResponse.data?.results else {
            return nil
        }
        return results
    }

    func makeEndpointURL<T: APIRequest>(for request: T) -> URL? {
        var components = URLComponents()
        components.scheme = GlobalConstants.MarvelAPI.scheme
        components.host = GlobalConstants.MarvelAPI.host
        components.path = path(for: request)
        components.port = GlobalConstants.MarvelAPI.port
        components.queryItems = parameters(for: request)
        return components.url
    }

    func path<T: APIRequest>(for request: T) -> String {
        return GlobalConstants.MarvelAPI.basePath + request.resourceName
    }

    func parameters<T: APIRequest>(for request: T) -> [URLQueryItem] {
        return encryptionParameters() + filterParameters(for: request)
    }

    func encryptionParameters() -> [URLQueryItem] {
        // Common query items needed for all Marvel requests
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = "\(timestamp)\(GlobalConstants.MarvelAPI.privateKey)\(GlobalConstants.MarvelAPI.publicKey)".md5()
        return [
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.timestamp,
                         value: timestamp),
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.hash,
                         value: hash),
            URLQueryItem(name: GlobalConstants.MarvelAPI.Parameters.apiKey,
                         value: GlobalConstants.MarvelAPI.publicKey)
        ]
    }

    func filterParameters<T: APIRequest>(for request: T) -> [URLQueryItem] {
        return request.parameters.map {
            // converts the value from Any to String
            URLQueryItem(name: $0.key,
                         value: String(describing: $0.value))
        }
    }
}

enum APIError: Error {
    case invalidURL
    case conversionDataFailed
    case unknown
}

protocol APIRequest {
    associatedtype Response: Decodable

    var resourceName: String { get }

    var parameters: [String: Any] { get }
}

struct GetComicCharactersRequest: APIRequest {
    typealias Response = [ComicCharacter]

    var resourceName: String {
        return GlobalConstants.MarvelAPI.Paths.characters
    }

    var parameters: [String: Any] {
        return [GlobalConstants.MarvelAPI.Parameters.limit: limit]
    }

    let limit: Int

    init(limit: Int = 10) {
        self.limit = limit
    }
}

struct ComicCharacter: Decodable {
    let id: String?
    let name: String?
    let description: String?
}

struct MarvelResponse<Response: Decodable>: Decodable {
    public let status: String?
    public let message: String?
    public let data: MarvelDataContainer<Response>?
}

struct MarvelDataContainer<Results: Decodable>: Decodable {
    public let offset: Int
    public let limit: Int
    public let total: Int
    public let count: Int
    public let results: Results
}

protocol Session {
    associatedtype Task: DataTask

    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Task
}

extension URLSession: Session {}

protocol DataTask {
    func resume()
}

extension URLSessionDataTask: DataTask {}


class House<S: FBFirestore> {
    var marvelAPI: FirebaseFirestore<S>?

    func something() {
        marvelAPI?.database.collection("").addDocument(data: ["": 2])
    }
}
