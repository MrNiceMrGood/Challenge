//
//  Request.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation
import Combine

struct Request {
    let endpoint: Endpoint
    let body: Data?
    let timeout: Double
    
    init(endpoint: Endpoint,
         body: Data? = nil,
         timeout: Double = 30) {
        self.endpoint = endpoint
        self.body = body
        self.timeout = timeout
    }
    
    func getUrlRequest() -> URLRequest? {
        guard let url = endpoint.fullUrl() else {
            debugPrint("Failed to get URL!")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = timeout
        
        for header in endpoint.headers {
            request.addValue(header.value, forHTTPHeaderField: header.name)
        }
        return request
    }
}
