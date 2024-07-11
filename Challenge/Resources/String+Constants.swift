//
//  String+Constants.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation
import SwiftUI

extension String {
    enum Key {
        case photoFeed
        case ok
        case defaultErrorMessage
        case badURL(description: String)
        case unauthorized(description: String)
        case unknown(description: String)
        case badRequest(description: String)
        case serverError(code: Int, description: String)
        case invalidJSON(description: String)
        case networkError(description: String)
        case badData
        
        var localizedValue: String {
            switch self {
            case .photoFeed:
                return String.localizedStringWithFormat(NSLocalizedString("photoFeed", comment: ""), [])
            case .ok:
                return String.localizedStringWithFormat(NSLocalizedString("ok", comment: ""), [])
            case .defaultErrorMessage:
                return String.localizedStringWithFormat(NSLocalizedString("defaultErrorMessage", comment: ""), [])
            case let .badURL(description):
                return String.localizedStringWithFormat(NSLocalizedString("badURL", comment: ""), [description])
            case let .unauthorized(description):
                return String.localizedStringWithFormat(NSLocalizedString("unauthorized", comment: ""), [description])
            case let .unknown(description):
                return String.localizedStringWithFormat(NSLocalizedString("unknown", comment: ""), [description])
            case let .badRequest(description):
                return String.localizedStringWithFormat(NSLocalizedString("badRequest", comment: ""), [description])
            case let .serverError(code, description):
                return String.localizedStringWithFormat(NSLocalizedString("serverError", comment: ""), [code, description])
            case let .invalidJSON(description):
                return String.localizedStringWithFormat(NSLocalizedString("invalidJSON", comment: ""), [description])
            case let .networkError(description):
                return String.localizedStringWithFormat(NSLocalizedString("networkError", comment: ""), [description])
            case .badData:
                return String.localizedStringWithFormat(NSLocalizedString("badData", comment: ""), [])
            }
        }
    }
}
