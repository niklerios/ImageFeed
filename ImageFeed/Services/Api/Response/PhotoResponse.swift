//
//  PhotoResponse.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

struct PhotoResponse: Decodable {
    struct Urls: Decodable {
        let thumb: String
        let regular: String
        let small: String
    }

    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: Urls
}
