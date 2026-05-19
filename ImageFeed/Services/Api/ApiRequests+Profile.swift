//
//  ApiRequests+Profile.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

extension ApiRequests {
    
    /// Запрос профиля пользователя
    static func fetchUserRequest(
        byName username: Int,
        completion: @escaping Completion<UserResponse>
    ) -> Request<UserResponse> {
        let networkURL = URLBuilder.base(path: "/users/\(username)")
        
        return Request(
            url: networkURL.url,
            requestId: .fetchUser,
            responseType: UserResponse.self,
            completion: completion
        )
    }
    
    /// Запрос профиля текущего юзера
    static func fetchMeRequest(completion: @escaping Completion<MeResponse>) -> Request<MeResponse> {
        let networkURL = URLBuilder.baseApi(path: "/me")
        
        return Request(
            url: networkURL.url,
            requestId: .fetchMe,
            responseType: MeResponse.self,
            authorization: true,
            completion: completion
        )
    }
}
