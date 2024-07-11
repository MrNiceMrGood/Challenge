//
//  CuratedResponseTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
@testable import Challenge

final class CuratedPhotosResponseTests: XCTestCase {
    func testCuratedPhotoResponseDecoding() throws {
        let jsonData = """
        {
            "id": 12345,
            "width": 1920,
            "height": 1080,
            "alt": "A beautiful landscape",
            "photographer": "Dejan",
            "src": {
                "original": "https://test.com/original.jpg",
                "medium": "https://test.com/medium.jpg"
            }
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let photo = try decoder.decode(CuratedPhotoResponse.self, from: jsonData)
        
        XCTAssertEqual(photo.id, 12345)
        XCTAssertEqual(photo.width, 1920)
        XCTAssertEqual(photo.height, 1080)
        XCTAssertEqual(photo.imageName, "A beautiful landscape")
        XCTAssertEqual(photo.photographer, "Dejan")
        XCTAssertEqual(photo.originalImageUrl, "https://test.com/original.jpg")
        XCTAssertEqual(photo.mediumImageUrl, "https://test.com/medium.jpg")
    }
    
    func testCuratedPhotosResponseDecoding() throws {
        let jsonData = """
        {
            "page": 1,
            "per_page": 2,
            "next_page": "https://api.test.com/curated/?page=2",
            "total_results": 100,
            "photos": [
                {
                    "id": 12345,
                    "width": 1920,
                    "height": 1080,
                    "alt": "A beautiful landscape",
                    "photographer": "Dejan",
                    "src": {
                        "original": "https://test.com/original.jpg",
                        "medium": "https://test.com/medium.jpg"
                    }
                },
                {
                    "id": 67890,
                    "width": 2048,
                    "height": 1365,
                    "alt": "A stunning sunset",
                    "photographer": "Me again",
                    "src": {
                        "original": "https://test.com/original2.jpg",
                        "medium": "https://test.com/medium2.jpg"
                    }
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(CuratedPhotosResponse.self, from: jsonData)
        
        XCTAssertEqual(response.page, 1)
        XCTAssertEqual(response.perPage, 2)
        XCTAssertEqual(response.nextPage, "https://api.test.com/curated/?page=2")
        XCTAssertEqual(response.totalResults, 100)
        
        XCTAssertEqual(response.photos.count, 2)
        
        let firstPhoto = response.photos[0]
        XCTAssertEqual(firstPhoto.id, 12345)
        XCTAssertEqual(firstPhoto.width, 1920)
        XCTAssertEqual(firstPhoto.height, 1080)
        XCTAssertEqual(firstPhoto.imageName, "A beautiful landscape")
        XCTAssertEqual(firstPhoto.photographer, "Dejan")
        XCTAssertEqual(firstPhoto.originalImageUrl, "https://test.com/original.jpg")
        XCTAssertEqual(firstPhoto.mediumImageUrl, "https://test.com/medium.jpg")
        
        let secondPhoto = response.photos[1]
        XCTAssertEqual(secondPhoto.id, 67890)
        XCTAssertEqual(secondPhoto.width, 2048)
        XCTAssertEqual(secondPhoto.height, 1365)
        XCTAssertEqual(secondPhoto.imageName, "A stunning sunset")
        XCTAssertEqual(secondPhoto.photographer, "Me again")
        XCTAssertEqual(secondPhoto.originalImageUrl, "https://test.com/original2.jpg")
        XCTAssertEqual(secondPhoto.mediumImageUrl, "https://test.com/medium2.jpg")
    }
}

