//
//  MediaModel.swift
//  MediaApp
//
//  Created by Argh on 10/7/24.
//

import Foundation

struct Media: Codable {
    let mediaURL: String
    let title, description: String
    let rating: Double
    let isLiked: Bool

    enum CodingKeys: String, CodingKey {
        case mediaURL = "mediaUrl"
        case title, description, rating, isLiked
    }
}
