//
//  ImagesListCellSettings.swift
//  ImageFeed
//
//  Created by Alfa on 28.03.2026.
//

import Foundation

struct ImagesListCellSettings {
    let imageURL: URL
    let isLiked: Bool
    let date: Date
    
    var dateString: String {
        date.dateTimeString
    }
}
