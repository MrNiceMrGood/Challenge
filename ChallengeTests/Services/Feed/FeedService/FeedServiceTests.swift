//
//  FeedServiceTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import XCTest
@testable import Challenge

final class FeedServiceTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadCuratedPhotosSuccess() throws {
        // Given
        let mockNetworkManager = MockNetworkManager()
        let service = FeedService(networkManager: mockNetworkManager)
        
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
        
        let expectedResponse = CuratedPhotosResponse(
            page: 1,
            perPage: 10,
            nextPage: "next_page_url",
            totalResults: 100,
            photos: [photo]
        )
        
        mockNetworkManager.result = Just(expectedResponse)
            .setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Loading curated photos succeeds")
        
        service.loadCuratedPhotos(photosPerPage: 10, pageNumber: 1)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { response in
                // Then
                XCTAssertEqual(response.page, expectedResponse.page)
                XCTAssertEqual(response.perPage, expectedResponse.perPage)
                XCTAssertEqual(response.nextPage, expectedResponse.nextPage)
                XCTAssertEqual(response.totalResults, expectedResponse.totalResults)
                XCTAssertEqual(response.photos.count, expectedResponse.photos.count)
                XCTAssertEqual(response.photos.first?.id, expectedResponse.photos.first?.id)
                XCTAssertEqual(response.photos.first?.width, expectedResponse.photos.first?.width)
                XCTAssertEqual(response.photos.first?.height, expectedResponse.photos.first?.height)
                XCTAssertEqual(response.photos.first?.imageName, expectedResponse.photos.first?.imageName)
                XCTAssertEqual(response.photos.first?.photographer, expectedResponse.photos.first?.photographer)
                XCTAssertEqual(response.photos.first?.mediumImageUrl, expectedResponse.photos.first?.mediumImageUrl)
                XCTAssertEqual(response.photos.first?.originalImageUrl, expectedResponse.photos.first?.originalImageUrl)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadCuratedPhotosFailure() {
        // Given
        let mockNetworkManager = MockNetworkManager()
        let service = FeedService(networkManager: mockNetworkManager)
        
        mockNetworkManager.result = Fail(error: NetworkError.badRequest(description: ""))
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Loading curated photos fails")
        
        service.loadCuratedPhotos(photosPerPage: 10, pageNumber: 1)
            .sink(receiveCompletion: { completion in
                // Then
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, NetworkError.badRequest(description: ""))
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got success")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

