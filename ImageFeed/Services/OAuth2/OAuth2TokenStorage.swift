//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Alfa on 10.05.2026.
//

import Foundation

protocol OAuth2TokenStorageProtocol: AnyObject {
    var token: String? { get set }
}

final class OAuth2TokenStorage: OAuth2TokenStorageProtocol {
    private enum Keys: String { case token }
    private let store: UserDefaults = .standard
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            store.string(forKey: Keys.token.rawValue)
        }
        set {
            store.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
