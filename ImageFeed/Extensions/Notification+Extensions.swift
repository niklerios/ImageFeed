//
//  Notification+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 23.05.2026.
//

import Foundation

extension Notification.Name {
    init(_ name: NotificationName) {
        self.init(rawValue: name.rawValue)
    }
}
