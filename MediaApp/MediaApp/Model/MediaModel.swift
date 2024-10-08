//
//  MediaModel.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

struct Media: Codable {
    let mediaURL: String
    let title, description: String?
    let rating: Double
    let isLiked: Bool
    let mediaType: MediaType
    
    enum CodingKeys: String, CodingKey {
        case mediaURL = "mediaUrl"
        case title, description, rating, isLiked
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mediaURL = try container.decode(String.self, forKey: .mediaURL)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.isLiked = try container.decode(Bool.self, forKey: .isLiked)
        
        if mediaURL.contains(".mp4") {
            self.mediaType = .video
        } else {
            self.mediaType = .photo
        }
    }
}
