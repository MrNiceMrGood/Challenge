//
//  MockNavigationViewController.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 11. 7. 2024..
//

import XCTest
import SwiftUI
@testable import Challenge

final class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        pushedViewController = viewController
    }

    var setViewControllersCalled = false
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        setViewControllersCalled = true
    }
}
