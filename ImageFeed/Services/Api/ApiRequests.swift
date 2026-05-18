//
//  ApiRequests.swift
//  ImageFeed
//
//  Created by Alfa on 18.05.2026.
//

enum ApiRequests {
    typealias Request<T> = NetworkRequest<T, ApiRequestIds>
    typealias Completion<T> = Request<T>.Completion
    typealias URLBuilder = NetworkURL<ApiQueryParams>
    
    static func fetchOAuthTokenRequest(
        code: String,
        completion: @escaping Completion<OAuthTokenResponseBody>
    ) -> Request<OAuthTokenResponseBody> {
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
            responseType: OAuthTokenResponseBody.self,
            completion: completion
        )
    }
    
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
