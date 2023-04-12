//
//  NetworkManager.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 21.02.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
    func request<T: Decodable>(urlString: String) async throws -> T
}

public final class NetworkManager {
    private let jsonService: JSONDecoderManagerProtocol
    init(jsonService: JSONDecoderManagerProtocol) {
        self.jsonService = jsonService
    }
}

//MARK: - NetworkManagerProtocol
extension NetworkManager: NetworkManagerProtocol {

    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession.shared
        let request = URLRequest(url: URL(string: urlString)!)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                let myError = NSError(domain: "my error domain", code: -123, userInfo: nil)
                completion(.failure(myError))
                return
            }
            self.jsonService.decode(data, completion: completion)
        }
        task.resume()
    }
    
    func request<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.url
        }
        let urlRequest = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try jsonService.decode(data)
    }
}

enum NetworkError: Error {
    case url
}
