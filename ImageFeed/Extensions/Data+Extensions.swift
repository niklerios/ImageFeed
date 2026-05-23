//
//  Data+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

import Foundation

extension Data {
    var utf8String: String {
        String(decoding: self, as: UTF8.self)
    }
}
