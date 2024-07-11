//
//  MockPhotoService.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 11. 7. 2024..
//

import Combine
import Foundation
import UIKit
@testable import Challenge

final class MockPhotoService: PhotoServiceProtocol {
    var mockImage: UIImage?
    var mockError: NetworkError?
    private(set) var clearCacheCalled = false

    func loadPhoto(from url: URL?) -> AnyPublisher<UIImage, NetworkError> {
        if let image = mockImage {
            return Just(image)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else if let error = mockError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkError.unknown(description: "Mocked error"))
                .eraseToAnyPublisher()
        }
    }

    func clearCache() {
        clearCacheCalled = true
    }
}
