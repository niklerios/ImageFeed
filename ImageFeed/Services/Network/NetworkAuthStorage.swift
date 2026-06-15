//
//  NetworkAuthStorage.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

import Foundation
import SwiftKeychainWrapper

protocol NetworkAuthStorageProtocol: AnyObject {
    var authToken: String? { get set }
    var tokenType: String? { get set }
    var username: String? { get set }
    
    func clean()
}

final class NetworkAuthStorage: NetworkAuthStorageProtocol {
    private enum Keys: String { case token, tokenType, username }
    private let store: UserDefaults = .standard
    private let secureStore: KeychainWrapper = .standard
    
    static let shared = NetworkAuthStorage()
    
    var authToken: String? {
        get {
            secureStore.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue else { return }
            secureStore.set(newValue, forKey: Keys.token.rawValue)
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
    
    var username: String? {
        get {
            store.string(forKey: Keys.username.rawValue)
        }
        set {
            store.set(newValue, forKey: Keys.username.rawValue)
        }
    }
    
    private init() {}
    
    func clean() {
        secureStore.removeAllKeys()
        
        store.dictionaryRepresentation().keys.forEach {
            store.removeObject(forKey: $0)
        }
    }
}
