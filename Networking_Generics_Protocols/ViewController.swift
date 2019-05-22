//
//  ViewController.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando on 22.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let marvelAPI = MarvelAPI(session: URLSession.shared)
        marvelAPI.run()
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
            print("This was called")
        }
        task.resume()
    }

    func downloadRequest<R: APIRequest>(_ request: R) -> R.Response {
        return request.response
    }
}

protocol APIRequest {
    associatedtype Response: Decodable

    var response: Response { get }
}

class Request: APIRequest {
    let response: [String] = []
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
