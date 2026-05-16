//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

protocol OAuth2ServiceProtocol: AnyObject {
    typealias Completion<T> = NetworkRequest<T>.Completion
    
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
        let networkURL = NetworkURL.base(path: "/oauth/token") { queryBuilder in
            queryBuilder
                .add(.redirect_uri, Constants.redirectURI)
                .add(.client_secret, Constants.secretKey)
                .add(.client_id, Constants.accessKey)
                .add(.grant_type, "authorization_code")
                .add(.code, code)
        }

        let networkRequest = NetworkRequest(
            url: networkURL.url,
            responseType: OAuthTokenResponseBody.self
        ) {
            if case let .success(data) = $0 {
                self.tokenStorage.token = data.accessToken
            }
            
            completion($0)
        }
        
        networkClient.post(with: networkRequest)
    }
}
