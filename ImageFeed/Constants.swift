//
//  Constants.swift
//  ImageFeed
//
//  Created by Alfa on 06.05.2026.
//

import Foundation

enum Constants {
    static let accessKey = getValue(fromEnv: "ACCESS_KEY")
    static let secretKey = getValue(fromEnv: "SECRET_KEY")
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let baseURLString = "https://unsplash.com"
    static let baseApiURLString = "https://api.unsplash.com"
}

// MARK: - Helpers
extension Constants {
    private static let env = ProcessInfo.processInfo.environment

    private static func getValue(fromEnv key: String) -> String {
        guard let value = env[key] else {
            assertionFailure("Отсутствует переменная окружения \(key)")
            return ""
        }
        
        return value
    }
}

