//
//  Photo.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

import UIKit

struct Photo {    
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    nonisolated init(from response: PhotoResponse) {
        id = response.id
        size = CGSize(width: response.width, height: response.height)
        createdAt = Date.from(response.createdAt)
        welcomeDescription = response.description
        thumbImageURL = response.urls.thumb
        largeImageURL = response.urls.regular

        // TODO: -
        isLiked = false
    }
}
