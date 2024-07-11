//
//  NetworkError.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badURL(description: String)
    case unauthorized(description: String)
    case unknown(description: String)
    case badRequest(description: String)
    case serverError(code: Int, description: String)
    case invalidJSON(description: String)
    case networkError(description: String)
    case badData
    
    var errorDescription: String? {
        switch self {
        case let .badURL(description):
            return String.Key.badURL(description: description).localizedValue
        case let .unauthorized(description):
            return String.Key.unauthorized(description: description).localizedValue
        case let .unknown(description):
            return String.Key.unknown(description: description).localizedValue
        case let .badRequest(description):
            return String.Key.badRequest(description: description).localizedValue
        case let .serverError(code, description):
            return String.Key.serverError(code: code, description: description).localizedValue
        case let .invalidJSON(description):
            return String.Key.invalidJSON(description: description).localizedValue
        case let .networkError(description):
            return String.Key.networkError(description: description).localizedValue
        case .badData:
            return String.Key.badData.localizedValue
        }
    }
}
