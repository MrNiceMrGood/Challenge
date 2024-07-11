//
//  PhotoService.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation
import UIKit
import SwiftUI
import Combine

protocol PhotoServiceProtocol: AnyObject {
    func loadPhoto(from url: URL?) -> AnyPublisher<UIImage, NetworkError>
    func clearCache()
}

final class PhotoService: PhotoServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let cache = NSCache<NSString, UIImage>()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        self.cache.countLimit = 50
    }
    
    func loadPhoto(from url: URL?) -> AnyPublisher<UIImage, NetworkError> {
        guard let url = url
        else {
            return Fail(error: NetworkError.badURL(description: "Photo URL is missing")).eraseToAnyPublisher()
        }
        
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            return Just(cachedImage)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        } else {
            return networkManager
                .loadData(from: url, timeout: 5)
                .flatMap { [weak self] data -> AnyPublisher<UIImage, NetworkError> in
                    if let image = UIImage(data: data) {
                        self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                        return Just(image)
                            .setFailureType(to: NetworkError.self)
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: NetworkError.badData)
                            .eraseToAnyPublisher()
                    }
                }
                .eraseToAnyPublisher()
        }
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
