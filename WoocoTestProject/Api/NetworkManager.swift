//
//  NetworkManager.swift
//  WoocoTestProject
//
//  Created by Sepehr Rezaei on 12/12/21.
//

import Moya

protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchProductsList(completion: @escaping (Result<[ProductResult], Error>) -> ())
}

class NetworkManager: Networkable {
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])

    func fetchProductsList(completion: @escaping (Result<[ProductResult], Error>) -> ()) {
        request(target: .products, completion: completion)
    }
    
}




private extension NetworkManager {
    private func request<T: Decodable>(target: API, completion: @escaping (Result<T, Error>) -> ()) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
