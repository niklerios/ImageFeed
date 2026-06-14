//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Alfa on 20.05.2026.
//

import Foundation

protocol ProfileImageServiceProtocol {
    typealias Completion<T> = ApiRequests.Completion<T>
    
    var avatarURLString: String? { get }
    func fetchProfileImageURL(username: String, completion: Completion<String>?)
    func cleanAvatar()
}

final class ProfileImageService: ProfileImageServiceProtocol {
    private let networkClient: NetworkClientProtocol

    static let shared = ProfileImageService()
    
    private(set) var avatarURLString: String?
    
    private init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }
    
    func fetchProfileImageURL(username: String, completion: Completion<String>? = nil) {
        let request = ApiRequests.fetchUserRequest(byName: username) {
            let result = $0.map(\.profileImage.small)
            
            if case let .success(urlString) = result {
                self.avatarURLString = urlString
                self.sendDidChangeNotification()
            }
            
            if let completion {
                completion(result)
            }
        }
        
        networkClient.get(with: request)
    }
    
    func cleanAvatar() {
        avatarURLString = nil
        sendDidChangeNotification()
    }
    
    private func sendDidChangeNotification() {
        NotificationCenter.default.post(
            name: AppNotification.profileImageDidChange.name,
            object: self
        )
    }
}

