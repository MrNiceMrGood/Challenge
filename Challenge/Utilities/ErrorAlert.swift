//
//  ErrorAlert.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import SwiftUI
import Foundation

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = String.Key.ok.localizedValue) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }
    
    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
