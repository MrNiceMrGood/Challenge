//
//  PhotoDetailsViewModel.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import Foundation
import UIKit

final class PhotoDetailsViewModel: ViewModel {
    @Published var photo: Photo
    @Published var image: UIImage?
    
    private var photoService: PhotoServiceProtocol
    
    init(photo: Photo, photoService: PhotoServiceProtocol) {
        self.photo = photo
        self.photoService = photoService
        super.init()
        loadOriginalImage()
    }
}

private extension PhotoDetailsViewModel {
    private func loadOriginalImage() {
        photoService
            .loadPhoto(from: URL(string: photo.imageUrl))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = error
                    self?.showError = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancelBag)
    }
}
