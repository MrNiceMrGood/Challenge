//
//  AppCoordinatorTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 11. 7. 2024..
//

import XCTest
import SwiftUI
@testable import Challenge

final class AppCoordinatorTests: XCTestCase {
    var mockNavigationController: MockNavigationController!
    var appCoordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        appCoordinator = AppCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        mockNavigationController = nil
        appCoordinator = nil
        super.tearDown()
    }

    func testStartFlowSetsInitialViewController() {
        // When
        appCoordinator.startFlow()

        // Then
        XCTAssertTrue(mockNavigationController.setViewControllersCalled)
        XCTAssertEqual(mockNavigationController.viewControllers.count, 1)
        XCTAssertTrue(mockNavigationController.viewControllers.first is UIHostingController<FeedView>)
    }

    func testRouteToDetailsPushesDetailViewController() {
        // Given
        let photo = Photo(id: 1, 
                          authorsName: "Dejan",
                          imageName: "Test Name",
                          imageUrl: "https://test.com/test.jpg",
                          mediumSizeImageUrl: "https://test.com/test.jpg")

        // When
        appCoordinator.routeToDetails(photo)

        // Then
        XCTAssertNotNil(mockNavigationController.pushedViewController)
        XCTAssertTrue(mockNavigationController.pushedViewController is UIHostingController<PhotoDetailsView>)
    }
}
