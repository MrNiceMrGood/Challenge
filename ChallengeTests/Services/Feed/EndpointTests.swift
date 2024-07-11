//
//  EndpointTests.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
@testable import Challenge

final class EndpointTests: XCTestCase {
    func testFullUrl() {
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
        
        // When
        let url = endpoint.fullUrl()
        
        // Then
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "api.example.com")
        XCTAssertEqual(url?.path, "/v1/test")
        
        let components = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        let expectedQueryItems = [
            URLQueryItem(name: "key1", value: "value1"),
            URLQueryItem(name: "key2", value: "value2")
        ]
        XCTAssertEqual(components?.queryItems, expectedQueryItems)
    }
    
    func testHttpMethodRawValues() {
        XCTAssertEqual(HTTPMethod.get.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.post.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.put.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.delete.rawValue, "DELETE")
    }
    
    func testHttpHeaderInitialization() {
        // Given
        let header = HTTPHeader(name: "Content-Type", value: "application/json")
        
        // Then
        XCTAssertEqual(header.name, "Content-Type")
        XCTAssertEqual(header.value, "application/json")
    }
}
