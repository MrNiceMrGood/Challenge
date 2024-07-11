//
//  CuratedPhotosResponse.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Foundation

struct CuratedPhotosResponse: Decodable {
    var page: Int
    var perPage: Int
    var nextPage: String
    var totalResults: Int
    var photos: [CuratedPhotoResponse]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case nextPage = "next_page"
        case totalResults = "total_results"
        case photos
    }
}

struct CuratedPhotoResponse: Decodable {
    var id: Double
    var width: Float
    var height: Float
    var imageName: String
    var photographer: String
    var mediumImageUrl: String
    var originalImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, width, height, photographer
        case src
        case imageName = "alt"
    }
    
    enum SrcCodingKeys: String, CodingKey {
        case original
        case medium
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Double.self, forKey: .id)
        width = try container.decode(Float.self, forKey: .width)
        height = try container.decode(Float.self, forKey: .height)
        imageName = try container.decode(String.self, forKey: .imageName)
        photographer = try container.decode(String.self, forKey: .photographer)
        
        let srcContainer = try container.nestedContainer(keyedBy: SrcCodingKeys.self, forKey: .src)
        originalImageUrl = try srcContainer.decode(String.self, forKey: .original)
        mediumImageUrl = try srcContainer.decode(String.self, forKey: .medium)
        
    }
}
