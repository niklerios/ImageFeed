//
//  UIImage+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 23.05.2026.
//

import UIKit

extension UIImage {
    convenience init?(appImageName: AppImageName) {
        self.init(systemName: appImageName.rawValue)
    }
}
