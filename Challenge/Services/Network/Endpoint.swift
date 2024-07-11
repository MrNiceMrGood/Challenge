//
//  Endpoint.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [HTTPHeader] { get }
    var method: HTTPMethod { get }
}

extension Endpoint {
    func fullUrl() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path
        components.queryItems = parameters
        return components.url
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct HTTPHeader: Hashable {
    public let name: String
    public let value: String
    
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
