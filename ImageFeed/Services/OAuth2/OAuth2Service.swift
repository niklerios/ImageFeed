//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

final class OAuth2Service: OAuth2ServiceProtocol {
    private let baseURLString = Constants.baseURLString

    private let networkClient: NetworkClientProtocol
    private var tokenStorage: OAuth2TokenStorageProtocol
    
    static let shared = OAuth2Service()
    
    init(
        networkClient: NetworkClientProtocol = NetworkClient.shared,
        tokenStorage: OAuth2TokenStorageProtocol = OAuth2TokenStorage.shared
    ) {
        self.networkClient = networkClient
        self.tokenStorage = tokenStorage
    }
    
    func fetchOAuthToken(with code: String, completion: @escaping Completion<String>) {
        guard let url = makeOAuthTokenURL(code: code) else {
            preconditionFailure("Unable to create URL for OAuth2 token fetching")
        }
        
        networkClient.post(url, responseType: OAuthTokenResponseBody.self) { result in
            switch result {
                case let .success(data):
                    self.tokenStorage.token = data.accessToken
                    completion(.success(data.accessToken))
                case let .failure(error):
                    error.log()
                    completion(.failure(error))
            }
        }
    }

    private func makeOAuthTokenURL(code: String) -> URL? {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            return nil
        }
        
        urlComponents.path = "/oauth/token"

        urlComponents.queryItems = [
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
        ]
        
        return urlComponents.url
    }
}
