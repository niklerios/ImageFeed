//
//  ApiRequests+Profile.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

extension ApiRequests {
    func fetchProfile(
        forUser username: Int,
        completion: @escaping Completion<ProfileResponse>
    ) -> Request<ProfileResponse> {
        let networkURL = URLBuilder.base(path: "/users/\(username)")
        
        return Request(
            url: networkURL.url,
            requestId: .fetchProfile,
            responseType: ProfileResponse.self,
            completion: completion
        )
    }
}
