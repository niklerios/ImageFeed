//
//  OAuthTokenResponse.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

struct OAuthTokenResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let username: Int
}
