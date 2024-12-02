//
//  NetworkManager.swift
//  CoreModule
//
//  Created by Mai Hassen on 30/11/2024.
//

import Foundation
import Combine
import Network

//public class NetworkManager {
//    private let baseURL = "https://api.themoviedb.org/3/"
//    private let apiKey = "9a1ba21f7104aed688c34f2bcb4a09f4"
//
//  
//    public init(){}
//    
//    public func fetch<T: Decodable>(_ endpoint: String) -> AnyPublisher<T, Error> {
//        guard let url = URL(string: "\(baseURL)\(endpoint)&api_key=\(apiKey)") else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: T.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    }
//
//
// 
//}




import Network
import Combine
import Foundation
import Network
import Combine


public class NetworkManager: ObservableObject {
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKey = "9a1ba21f7104aed688c34f2bcb4a09f4"
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    @Published public var isOnline: Bool = true  // Network status
    private var cancellables = Set<AnyCancellable>()

    // Singleton instance to ensure we are using the same instance throughout the app
    public static let shared = NetworkManager()

    // Initialization to start monitoring
    public init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOnline = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue) // Start monitoring immediately

        // Ensure initial status is checked, just to make sure we're not depending on default value
        checkNetworkStatus()
    }

    // Manually trigger a check for network status (to ensure it’s up-to-date early)
    private func checkNetworkStatus() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // Wait a little to get a fresh network status
        }
    }

    // Network request
    public func fetch<T: Decodable>(_ endpoint: String) -> AnyPublisher<T, Error> {
        guard isOnline else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }

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
