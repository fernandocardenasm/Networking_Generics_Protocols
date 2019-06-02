//
//  MarvelAPI.swift
//  Networking_Generics_Protocols
//
//  Created by Fernando Cardenas on 28.05.19.
//  Copyright © 2019 Fernando. All rights reserved.
//

import Foundation

// This protocol cannot have the associatedType just the class that implements it
// Just the method, I did not delete it, so the the comment is more clear.
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
}

extension MarvelAPI {
    // TODO: Maybe this should be an extra struct with static functions.
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
