//
//  Profile.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

struct Profile {
    let username: String
    let name: String
    let login: String
    let bio: String?
}

extension Profile {
    init(_ response: MeResponse) {
        username = response.username
        name = "\(response.firstName) \(response.lastName)"
        login = "@\(response.username)"
        bio = response.bio
    }
}
