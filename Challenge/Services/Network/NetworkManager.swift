//
//  Request.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import Foundation
import UIKit

protocol NetworkManagerProtocol {
    func performRequest<T: Decodable>(_ request: Request) -> AnyPublisher<T, NetworkError>
    func loadData(from url: URL, timeout: Double) -> AnyPublisher<Data, NetworkError>
}

final class NetworkManager: NetworkManagerProtocol {
    private var decoder: JSONDecoder
    private var sessionConfiguration: URLSessionConfiguration
    
    init(decoder: JSONDecoder = JSONDecoder(),
         sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default,
         timeout: Double = 30) {
        self.decoder = decoder
        self.sessionConfiguration = sessionConfiguration
    }
    
    func performRequest<T>(_ request: Request) -> AnyPublisher<T, NetworkError> where T: Decodable {
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(request.timeout)
        let session = URLSession(configuration: sessionConfiguration)
        guard let urlRequest = request.getUrlRequest() else {
            return Fail(error: NetworkError.badRequest(description: "Failed to create URL Request"))
                .eraseToAnyPublisher()
        }
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.serverError(code: 0, description: "Invalid response")
                }
                
                guard (200...299).contains(response.statusCode) else {
                    throw NetworkError.serverError(code: response.statusCode, description: "Server Error")
                }
                
                return output.data
            }
            .mapError { error -> NetworkError in
                if let urlError = error as? URLError {
                    return NetworkError.networkError(description: urlError.localizedDescription)
                } else if let decodingError = error as? DecodingError {
                    return NetworkError.invalidJSON(description: decodingError.localizedDescription)
                } else if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.unknown(description: error.localizedDescription)
                }
            }
            .flatMap { data in
                Just(data)
                    .decode(type: T.self, decoder: self.decoder)
                    .mapError { NetworkError.invalidJSON(description: $0.localizedDescription) }
            }
            .eraseToAnyPublisher()
    }
    
    func loadData(from url: URL, timeout: Double) -> AnyPublisher<Data, NetworkError> {
        sessionConfiguration.timeoutIntervalForRequest = TimeInterval(timeout)
        let session = URLSession(configuration: sessionConfiguration)
        return session
            .dataTaskPublisher(for: url)
            .compactMap { $0.data }
            .mapError { error in
                return NetworkError.networkError(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
