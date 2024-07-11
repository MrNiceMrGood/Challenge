//
//  MockEndpoint.swift
//  ChallengeTests
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import XCTest
@testable import Challenge

struct MockEndpoint: Endpoint {
    var baseUrl: String
    var path: String
    var parameters: [URLQueryItem]
    var headers: [HTTPHeader]
    var method: HTTPMethod
}
