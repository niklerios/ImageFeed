//
//  EnvHelper.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

import XCTest

struct EnvHelper {
    private let env = ProcessInfo.processInfo.environment
    
    enum EnvNames: String, CaseIterable {
        case email = "EMAIL"
        case password = "PASSWORD"
        case username = "USERNAME"
        case userId = "USER_ID"
        case accessKey = "ACCESS_KEY"
        case secretKey = "SECRET_KEY"
    }
    
    private let envs = EnvNames.allCases
    
    var isAllEnvsSet: Bool {
        envs.map({ self[nameOptional: $0] }).compactMap({ $0 }).count == envs.count
    }
    
    var allEnvNames: String {
        EnvNames.allCases.map(\.rawValue).joined(separator: ", ")
    }
    
    subscript(name envName: EnvNames) -> String {
        env[envName.rawValue]!
    }
    
    private subscript(nameOptional envName: EnvNames) -> String? {
        env[envName.rawValue]
    }
}
