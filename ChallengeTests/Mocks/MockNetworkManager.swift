//
//  MockNetworkManager.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import XCTest
@testable import Challenge

final class MockNetworkManager: NetworkManagerProtocol {
    var result: AnyPublisher<CuratedPhotosResponse, NetworkError>?
    var loadDataResult: Result<Data, NetworkError>?

    func performRequest<T>(_ request: Request) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let result = result as? AnyPublisher<T, NetworkError> else {
            fatalError("Unexpected result type")
        }
        return result
    }

    func loadData(from photoUrl: URL, timeout: Double) -> AnyPublisher<Data, NetworkError> {
        guard let result = loadDataResult else {
            return Fail(error: NetworkError.networkError(description: "No result set")).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
