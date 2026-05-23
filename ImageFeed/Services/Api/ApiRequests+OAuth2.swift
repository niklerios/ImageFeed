//
//  OAuth2Requests.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

extension ApiRequests {
    /// Запрос на токен авторизации
    ///
    /// - Parameter code: код авторизации ,пришедший от WebView со страницы oauth
    static func fetchOAuthTokenRequest(
        code: String,
        completion: @escaping Completion<OAuthTokenResponse>
    ) -> Request<OAuthTokenResponse> {
        let networkURL = URLBuilder.base(path: "/oauth/token") { queryParams in
            queryParams
                .add(.redirect_uri, Constants.redirectURI)
                .add(.client_secret, Constants.secretKey)
                .add(.client_id, Constants.accessKey)
                .add(.grant_type, "authorization_code")
                .add(.code, code)
        }

        return Request(
            url: networkURL.url,
            requestId: .fetchOAuthToken,
            responseType: OAuthTokenResponse.self,
            completion: completion
        )
    }
    
    /// Запрос на отображение страницы oauth
    static func loadAuthWebPageRequest() -> Request<Void> {
        let networkURL = URLBuilder.base(path: "/oauth/authorize") { queryParams in
            queryParams
                .add(.client_id, Constants.accessKey)
                .add(.redirect_uri, Constants.redirectURI)
                .add(.response_type, "code")
                .add(.scope, Constants.accessScope)
        }
        
        return Request(
            url: networkURL.url,
            responseType: Void.self
        )
    }
}
