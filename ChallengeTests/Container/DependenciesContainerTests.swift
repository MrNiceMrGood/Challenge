//
//  DependenciesContainerTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 11. 7. 2024..
//

import XCTest
@testable import Challenge

final class DependenciesContainerTests: XCTestCase {
    
    private var dependenciesContainer: DependenciesContainer!
    
    override func setUp() {
        super.setUp()
        dependenciesContainer = DependenciesContainer()
    }
    
    override func tearDown() {
        dependenciesContainer = nil
        super.tearDown()
    }
    
    func testGetNetworkManager() {
        // Given
        let networkManager = dependenciesContainer.getNetworkManager()
        
        // When & Then
        XCTAssertTrue(networkManager is NetworkManager)
    }
    
    func testGetFeedService() {
        // Given
        let feedService = dependenciesContainer.getFeedService()
        
        // When & Then
        XCTAssertTrue(feedService is FeedService)
    }
    
    func testGetPhotoService() {
        // Given
        let photoService = dependenciesContainer.getPhotoService()
        
        // When & Then
        XCTAssertTrue(photoService is PhotoService)
    }
}
