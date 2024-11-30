//
//  NetworkManager.swift
//  CoreModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
import Combine

public class NetworkManager {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "9a1ba21f7104aed688c34f2bcb4a09f4"

  
    public init(){}
    
    public func fetch<T: Decodable>(_ endpoint: String) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)\(endpoint)&api_key=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
 
}
