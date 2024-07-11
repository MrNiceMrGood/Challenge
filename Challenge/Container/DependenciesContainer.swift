//
//  DependenciesContainer.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

final class DependenciesContainer {
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let photoService: PhotoServiceProtocol
    private let feedService: FeedServiceProtocol
    
    init() {
        self.photoService = PhotoService(networkManager: networkManager)
        self.feedService = FeedService(networkManager: networkManager)
    }
    
    func getNetworkManager() -> NetworkManagerProtocol {
        return networkManager
    }
    
    func getFeedService() -> FeedServiceProtocol {
        return feedService
    }
    
    func getPhotoService() -> PhotoServiceProtocol {
        return photoService
    }
}
