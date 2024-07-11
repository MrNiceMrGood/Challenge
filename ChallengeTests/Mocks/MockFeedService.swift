//
//  MockFeedService.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
@testable import Challenge

final class MockFeedService: FeedServiceProtocol {
    var loadCuratedPhotosResult: Result<CuratedPhotosResponse, NetworkError>?
    
    func loadCuratedPhotos(photosPerPage: Int, pageNumber: Int) -> AnyPublisher<CuratedPhotosResponse, NetworkError> {
        guard let result = loadCuratedPhotosResult else {
            return Fail(error: NetworkError.unknown(description: "No result set")).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}
