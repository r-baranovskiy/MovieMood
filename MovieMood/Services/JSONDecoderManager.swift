//
//  JSONDecoderManager.swift
//  RecipeBookChallenge
//
//  Created by Сергей Золотухин on 21.02.2023.
//

import Foundation

protocol JSONDecoderManagerProtocol {
    func decode<T: Decodable>(_ data: Data) -> T?
    func decode<T: Decodable>(_ data: Data, completion: (Result<T, Error>) -> Void)
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class JSONDecoderManager {
    
    private let decoder = JSONDecoder()
    
    public init() {}
}

//MARK: - JSONDecoderManagerProtocol
extension JSONDecoderManager: JSONDecoderManagerProtocol {
    
    func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            print(error, error.localizedDescription)
            return nil
        }
    }
    
    func decode<T: Decodable>(_ data: Data, completion: (Result<T, Error>) -> Void) {
        
        do {
            let result = try decoder.decode(T.self, from: data)
            return completion(.success(result))
        } catch {
            return completion(.failure(error))
        }
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
            return try decoder.decode(T.self, from: data)
    }
}
