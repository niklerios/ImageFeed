//
//  AppNotification.swift
//  ImageFeed
//
//  Created by Alfa on 23.05.2026.
//

import Foundation

enum AppNotification: String {
    case profileImageDidChange
    case newPhotosDidLoad
    
    var name: Notification.Name {
        Notification.Name(rawValue)
    }
}
