//
//  FeedEndpointsTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
@testable import Challenge

final class FeedEndpointsTests: XCTestCase {
    func testCuratedPhotosBaseUrl() {
        // Given
        let endpoint = FeedEndpoints.curatedPhotos(page: 1, photosPerPage: 10)
        
        // When
        let baseUrl = endpoint.baseUrl
        
        // Then
        XCTAssertEqual(baseUrl, "api.pexels.com")
    }
    
    func testCuratedPhotosPath() {
        // Given
        let endpoint = FeedEndpoints.curatedPhotos(page: 1, photosPerPage: 10)
        
        // When
        let path = endpoint.path
        
        // Then
        XCTAssertEqual(path, "/v1/curated")
    }
    
    func testCuratedPhotosParameters() {
        // Given
        let endpoint = FeedEndpoints.curatedPhotos(page: 1, photosPerPage: 10)
        
        // When
        let parameters = endpoint.parameters
        
        // Then
        XCTAssertEqual(parameters.count, 2)
        XCTAssertTrue(parameters.contains(URLQueryItem(name: "page", value: "1")))
        XCTAssertTrue(parameters.contains(URLQueryItem(name: "per_page", value: "10")))
    }
    
    func testCuratedPhotosHeaders() {
        // Given
        let endpoint = FeedEndpoints.curatedPhotos(page: 1, photosPerPage: 10)
        
        // When
        let headers = endpoint.headers
        
        // Then
        XCTAssertEqual(headers.count, 1)
        XCTAssertEqual(headers.first?.name, "Authorization")
        XCTAssertEqual(headers.first?.value, "hGy36cD0G8UxitYWFqA9XxpaWmGFfMDa2KPVtvZ5Nz3INBe1E4d1VwmT")
    }
    
    func testCuratedPhotosMethod() {
        // Given
        let endpoint = FeedEndpoints.curatedPhotos(page: 1, photosPerPage: 10)
        
        // When
        let method = endpoint.method
        
        // Then
        XCTAssertEqual(method, .get)
    }
}

