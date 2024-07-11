//
//  MockCoordinator.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 11. 7. 2024..
//

import Foundation
import UIKit
@testable import Challenge

final class MockCoordinator: Coordinator {
    var navigationController: UINavigationController = UINavigationController()
    var routeToDetailsResult: Photo?
    var startFlowCalled = false

    func startFlow() {
        startFlowCalled = true
    }

    func routeToDetails(_ photo: Photo) {
        routeToDetailsResult = photo
    }
}
