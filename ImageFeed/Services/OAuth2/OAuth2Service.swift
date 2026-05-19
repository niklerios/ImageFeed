//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

protocol OAuth2ServiceProtocol: AnyObject {
    typealias Completion<T> = ApiRequests.Completion<T>
    
    func fetchOAuthToken(
        with code: String,
        completion: @escaping Completion<OAuthTokenResponse>
    )
}

final class OAuth2Service: OAuth2ServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private var authStorage: NetworkAuthStorageProtocol
    
    static let shared = OAuth2Service()
    
    private init(
        networkClient: NetworkClientProtocol = NetworkClient.shared,
        authStorage: NetworkAuthStorageProtocol = NetworkAuthStorage.shared
    ) {
        self.networkClient = networkClient
        self.authStorage = authStorage
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping Completion<OAuthTokenResponse>) {
        let request = ApiRequests.fetchOAuthTokenRequest(code: code) {
            if case let .success(data) = $0 {
                self.authStorage.authToken = data.accessToken
                self.authStorage.tokenType = data.tokenType
                self.authStorage.username = data.username
            }
            
            completion($0)
        }
        
        networkClient.post(with: request)
    }
}
