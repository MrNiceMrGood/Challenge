//
//  FeedEndpoints.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

enum FeedEndpoints: Endpoint {
    case curatedPhotos(page: Int, photosPerPage: Int)
    
    var baseUrl: String {
        switch self {
        case .curatedPhotos:
            return "api.pexels.com"
        }
    }
    
    var path: String {
        switch self {
        case .curatedPhotos:
            return "/v1/curated"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case let .curatedPhotos(page, photosPerPage):
            return [URLQueryItem(name: "per_page", value: "\(photosPerPage)"),
                    URLQueryItem(name: "page", value: "\(page)")]
        }
    }
    
    var headers: [HTTPHeader] {
        switch self {
        case .curatedPhotos:
            return [HTTPHeader(name: "Authorization",
                               value: "hGy36cD0G8UxitYWFqA9XxpaWmGFfMDa2KPVtvZ5Nz3INBe1E4d1VwmT")]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .curatedPhotos:
            return .get
        }
    }
}
