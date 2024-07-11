//
//  Photo.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

struct Photo: Identifiable {
    let id: Double
    let authorsName: String
    let imageName: String
    let imageUrl: String
    let mediumSizeImageUrl: String
    
    init(id: Double,
         authorsName: String,
         imageName: String,
         imageUrl: String,
         mediumSizeImageUrl: String) {
        self.id = id
        self.authorsName = authorsName
        self.imageName = imageName
        self.imageUrl = imageUrl
        self.mediumSizeImageUrl = mediumSizeImageUrl
    }
    
    init(response: CuratedPhotoResponse) {
        self.id = response.id
        self.imageName = response.imageName
        self.authorsName = response.photographer
        self.imageUrl = response.originalImageUrl
        self.mediumSizeImageUrl = response.mediumImageUrl
    }
}
