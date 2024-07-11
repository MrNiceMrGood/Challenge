//
//  ViewModelTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
import Combine
@testable import Challenge

final class ViewModelTests: XCTestCase {
  var viewModel: ViewModel!
  
  override func setUp() {
    super.setUp()
    viewModel = ViewModel()
  }
  
  override func tearDown() {
    viewModel = nil
    super.tearDown()
  }
  
  func testInitialState() {
    // Test the initial state of the ViewModel
    XCTAssertFalse(viewModel.showError)
    XCTAssertNil(viewModel.error)
  }
  
  func testErrorHandling() {
    // Given
    let testError = NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
    
    // When
    viewModel.error = testError
    
    // Then
    XCTAssertTrue(viewModel.showError)
    XCTAssertNotNil(viewModel.error)
    XCTAssertEqual(viewModel.error as NSError?, testError)
  }
  
  func testOnErrorAlertClose() {
    // Given
    let testError = NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)
    viewModel.error = testError
    
    // When
    viewModel.onErrorAlertClose()
    
    // Then
    XCTAssertFalse(viewModel.showError)
    XCTAssertNil(viewModel.error)
  }
}

