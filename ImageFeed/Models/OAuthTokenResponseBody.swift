//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    var accessToken: String { access_token }
}
