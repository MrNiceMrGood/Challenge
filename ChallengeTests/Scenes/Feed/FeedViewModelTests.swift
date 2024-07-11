//
//  FeedViewModelTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import XCTest
@testable import Challenge

final class FeedViewModelTests: XCTestCase {
    private var viewModel: FeedViewModel!
    private var mockFeedService: MockFeedService!
    private var mockPhotoService: MockPhotoService!
    private var mockCoordinator: MockCoordinator!
    private var cancellables: Set<AnyCancellable>!
    
    private let jsonData = """
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
    
    override func setUp() {
        super.setUp()
        mockFeedService = MockFeedService()
        mockPhotoService = MockPhotoService()
        mockCoordinator = MockCoordinator()
        viewModel = FeedViewModel(coordinator: mockCoordinator,
                                  feedService: mockFeedService,
                                  photoService: mockPhotoService,
                                  photosPerPage: 2)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockFeedService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testLoadFeedSuccess() throws {
        // Given
        let decoder = JSONDecoder()
        let response = try decoder.decode(CuratedPhotosResponse.self, from: jsonData)
        mockFeedService.loadCuratedPhotosResult = .success(response)
        
        // When
        viewModel.loadFeed(refresh: true)
        
        // Then
        let expectation = self.expectation(description: "Feed loaded")
        
        viewModel.$photos
            .dropFirst() // skip the initial value
            .sink { photos in
                XCTAssertEqual(photos.count, 2)
                XCTAssertEqual(photos[0].id, 12345)
                XCTAssertEqual(photos[1].id, 67890)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testLoadFeedFailure() throws {
        // Given
        let error = NetworkError.serverError(code: 500, description: "Server Error")
        mockFeedService.loadCuratedPhotosResult = .failure(error)
        
        // When
        viewModel.loadFeed(refresh: true)
        
        // Then
        let expectation = self.expectation(description: "Feed load failed")
        
        var showErrorReceived = false
        let cancellable = viewModel.$showError
            .dropFirst() // Skip initial value
            .sink { showError in
                if showError && !showErrorReceived {
                    XCTAssertTrue(self.viewModel.photos.isEmpty)
                    XCTAssertNotNil(self.viewModel.error)
                    XCTAssertTrue(showError)
                    showErrorReceived = true
                    expectation.fulfill()
                }
            }
        defer { cancellable.cancel() }
        
        waitForExpectations(timeout: 5.0)
        XCTAssertTrue(showErrorReceived, "Expected to receive showError == true")
    }
    
    func testLoadMorePhotosIfNeeded() throws {
        // Given
        let decoder = JSONDecoder()
        let response = try decoder.decode(CuratedPhotosResponse.self, from: jsonData)
        mockFeedService.loadCuratedPhotosResult = .success(response)
        viewModel.loadFeed(refresh: true)
        
        let expectation = self.expectation(description: "Feed loaded")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.loadMorePhotosIfNeeded(photo: self.viewModel.photos.last!)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testRefreshFeed() throws {
        // Given
        let decoder = JSONDecoder()
        let response = try decoder.decode(CuratedPhotosResponse.self, from: jsonData)
        mockFeedService.loadCuratedPhotosResult = .success(response)
        
        // When
        viewModel.refreshFeed()
        
        // Then
        let expectation = self.expectation(description: "Feed refreshed")
        viewModel.$photos
            .dropFirst() // skip the initial value
            .sink { photos in
                XCTAssertEqual(photos.count, 2)
                XCTAssertEqual(photos[0].id, 12345)
                XCTAssertEqual(photos[1].id, 67890)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
}
