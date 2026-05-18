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
        completion: @escaping Completion<OAuthTokenResponseBody>
    )
}

final class OAuth2Service: OAuth2ServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private var tokenStorage: OAuth2TokenStorageProtocol
    
    static let shared = OAuth2Service()
    
    private init(
        networkClient: NetworkClientProtocol = NetworkClient.shared,
        tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) {
        self.networkClient = networkClient
        self.tokenStorage = tokenStorage
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping Completion<OAuthTokenResponseBody>) {
        let request = ApiRequests.fetchOAuthTokenRequest(code: code) {
            if case let .success(data) = $0 {
                self.tokenStorage.token = data.accessToken
            }
            
            completion($0)
        }
        
        networkClient.post(with: request)
    }
}
