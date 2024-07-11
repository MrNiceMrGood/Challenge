//
//  FeedService.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation
import Combine

protocol FeedServiceProtocol {
    func loadCuratedPhotos(photosPerPage: Int,
                           pageNumber: Int) -> AnyPublisher<CuratedPhotosResponse, NetworkError>
}

final class FeedService: FeedServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func loadCuratedPhotos(photosPerPage: Int,
                           pageNumber: Int) -> AnyPublisher<CuratedPhotosResponse, NetworkError> {
        let endpoint = FeedEndpoints.curatedPhotos(page: pageNumber,
                                                   photosPerPage: photosPerPage)
        let request = Request(endpoint: endpoint)
        return networkManager.performRequest(request)
    }
}
