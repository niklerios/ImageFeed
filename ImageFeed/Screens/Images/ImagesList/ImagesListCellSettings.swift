//
//  ImagesListCellSettings.swift
//  ImageFeed
//
//  Created by Alfa on 28.03.2026.
//

import UIKit

struct ImagesListCellSettings {
    let image: UIImage
    let isLiked: Bool
    let date: Date
    
    var dateString: String {
        date.dateTimeString
    }
}
