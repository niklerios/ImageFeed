//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

protocol ProfileServiceProtocol: AnyObject {
    typealias Completion<T> = ApiRequests.Completion<T>

    func fetchProfile(completion: @escaping Completion<Profile>)
}

final class ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    static let shared = ProfileService()
    
    private(set) var profile: Profile?
    
    private init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }

    func fetchProfile(completion: @escaping Completion<Profile>) {
        let request = ApiRequests.fetchMeRequest {
            let result = $0.map(Profile.init)
            
            if case let .success(profile) = result {
                self.profile = profile
            }

            completion(result)
        }
        
        networkClient.get(with: request)
    }
}
