//
//  MeResponse.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

struct MeResponse: Decodable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
