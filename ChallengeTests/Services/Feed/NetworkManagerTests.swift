//
//  NetworkManagerTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
import Combine
@testable import Challenge

final class NetworkManagerTests: XCTestCase {
  private var cancellables: Set<AnyCancellable>!
  private var networkManager: NetworkManager!

  override func setUp() {
    super.setUp()
    cancellables = []

    // Set up URLProtocol to use MockURLProtocol
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLProtocol.self]
    networkManager = NetworkManager(decoder: JSONDecoder(), sessionConfiguration: config)
  }

  override func tearDown() {
    cancellables = nil
    super.tearDown()
  }

  func testPerformRequestSuccess() {
    // Given
    let expectedData = "{\"key\":\"value\"}".data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "https://api.example.com/v1/test")!,
                                   statusCode: 200, httpVersion: nil, headerFields: nil)!
    MockURLProtocol.requestHandler = { request in
      return (response, expectedData)
    }

    let request = Request(endpoint: MockEndpoint(
      baseUrl: "api.example.com",
      path: "/v1/test",
      parameters: [],
      headers: [],
      method: .get
    ))

    let expectation = self.expectation(description: "Perform request succeeds")

    // When
    networkManager.performRequest(request)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          XCTFail("Expected success but got failure with \(error)")
        }
      }, receiveValue: { (result: [String: String]) in
        XCTAssertEqual(result["key"], "value")
        expectation.fulfill()
      })
      .store(in: &cancellables)

    waitForExpectations(timeout: 1.0)
  }

  func testPerformRequestFailure() {
    // Given
    let response = HTTPURLResponse(url: URL(string: "https://api.example.com/v1/test")!,
                                   statusCode: 500, httpVersion: nil, headerFields: nil)!
    MockURLProtocol.requestHandler = { request in
      return (response, Data())
    }

    let request = Request(endpoint: MockEndpoint(
      baseUrl: "api.example.com",
      path: "/v1/test",
      parameters: [],
      headers: [],
      method: .get
    ))

    let expectation = self.expectation(description: "Perform request fails")

    // When
    networkManager.performRequest(request)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          if case .serverError(let code, let description) = error {
            XCTAssertEqual(code, 500)
            XCTAssertEqual(description, "Server Error")
          } else {
            XCTFail("Expected serverError but got \(error)")
          }
          expectation.fulfill()
        case .finished:
          XCTFail("Expected failure but got success")
        }
      }, receiveValue: { (result: [String: String]) in
        XCTFail("Expected failure but got success with \(result)")
      })
      .store(in: &cancellables)

    waitForExpectations(timeout: 1.0)
  }

  func testGetUrlRequestWithBodyAndTimeout() {
    // Given
    let expectedData = "{\"key\":\"value\"}".data(using: .utf8)!
    let response = HTTPURLResponse(url: URL(string: "https://api.example.com/v1/test")!,
                                   statusCode: 200, httpVersion: nil, headerFields: nil)!
    MockURLProtocol.requestHandler = { request in
      return (response, expectedData)
    }

    let bodyData = "{\"key\":\"value\"}".data(using: .utf8)!
    let timeout: Double = 10.0
    let request = Request(endpoint: MockEndpoint(
      baseUrl: "api.example.com",
      path: "/v1/test",
      parameters: [],
      headers: [],
      method: .post
    ), body: bodyData, timeout: timeout)

    let expectation = self.expectation(description: "Perform request with body and timeout")

    // When
    networkManager.performRequest(request)
      .sink(receiveCompletion: { completion in
        if case .failure(let error) = completion {
          XCTFail("Expected success but got failure with \(error)")
        }
      }, receiveValue: { (result: [String: String]) in
        XCTAssertEqual(result["key"], "value")
        expectation.fulfill()
      })
      .store(in: &cancellables)

    waitForExpectations(timeout: TimeInterval(timeout + 1.0))
  }
}
