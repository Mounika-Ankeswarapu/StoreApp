//
//  NetworkManager.swift
//  StoreApp
//
//  Created by Mounika Ankeswarapu on 15/04/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingFailed
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchProducts(completion: @escaping (Result<[ProductDataModel], NetworkError>) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            completion(.failure(.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([ProductDataModel].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(.decodingFailed))
            }
        }
        
        task.resume()
    }
}
