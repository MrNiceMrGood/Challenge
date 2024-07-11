//
//  ViewModel.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import Foundation

class ViewModel: ObservableObject {
    var cancelBag: Set<AnyCancellable> = []
    
    @Published var showError = false
    
    var error: Error? {
        didSet {
            showError = error != nil
        }
    }
    
    func onErrorAlertClose() {
        error = nil
    }
}
