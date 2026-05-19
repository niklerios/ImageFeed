//
//  NetworkAuthStorage.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

import Foundation

protocol NetworkAuthStorageProtocol: AnyObject {
    var authToken: String? { get set }
    var tokenType: String? { get set }
    var username: Int? { get set }
}

final class NetworkAuthStorage: NetworkAuthStorageProtocol {
    private enum Keys: String { case token, tokenType, username }
    private let store: UserDefaults = .standard
    
    static let shared = NetworkAuthStorage()
    
    var authToken: String? {
        get {
            store.string(forKey: Keys.token.rawValue)
        }
        set {
            store.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    var tokenType: String? {
        get {
            store.string(forKey: Keys.tokenType.rawValue)
        }
        set {
            store.set(newValue, forKey: Keys.tokenType.rawValue)
        }
    }
    
    var username: Int? {
        get {
            store.integer(forKey: Keys.username.rawValue)
        }
        set {
            store.set(newValue, forKey: Keys.username.rawValue)
        }
    }
    
    private init() {}
}
