//
//  RequestTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
@testable import Challenge

final class RequestTests: XCTestCase {
    func testGetUrlRequest() {
        // Given
        let endpoint = MockEndpoint(
            baseUrl: "api.example.com",
            path: "/v1/test",
            parameters: [
                URLQueryItem(name: "key1", value: "value1"),
                URLQueryItem(name: "key2", value: "value2")
            ],
            headers: [
                HTTPHeader(name: "Authorization", value: "Bearer token")
            ],
            method: .get
        )
        
        let request = Request(endpoint: endpoint)
        
        // When
        let urlRequest = request.getUrlRequest()
        
        // Then
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.scheme, "https")
        XCTAssertEqual(urlRequest?.url?.host, "api.example.com")
        XCTAssertEqual(urlRequest?.url?.path, "/v1/test")
        
        let components = URLComponents(url: urlRequest!.url!, resolvingAgainstBaseURL: false)
        let expectedQueryItems = [
            URLQueryItem(name: "key1", value: "value1"),
            URLQueryItem(name: "key2", value: "value2")
        ]
        XCTAssertEqual(components?.queryItems, expectedQueryItems)
        
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertEqual(urlRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer token")
    }
    
    func testGetUrlRequestWithoutBodyAndTimeout() {
        // Given
        let endpoint = MockEndpoint(
            baseUrl: "api.example.com",
            path: "/v1/test",
            parameters: [URLQueryItem(name: "test", value: "test")],
            headers: [],
            method: .get
        )
        let request = Request(endpoint: endpoint)
        
        // When
        let urlRequest = request.getUrlRequest()
        
        // Then
        XCTAssertNotNil(urlRequest)
        XCTAssertEqual(urlRequest?.url?.absoluteString, "https://api.example.com/v1/test?test=test")
        XCTAssertEqual(urlRequest?.httpMethod, "GET")
        XCTAssertNil(urlRequest?.httpBody)
        XCTAssertEqual(urlRequest?.timeoutInterval, 30.0)
    }
}
