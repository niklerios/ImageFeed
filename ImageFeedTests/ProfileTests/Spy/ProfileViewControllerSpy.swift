//
//  ProfileViewControllerSpy.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var navigateToAuthCalled = false

    var avatarURL: URL?
    var name: String?
    var username: String?
    var bio: String?
    
    var presenter: ProfilePresenterProtocol?
    
    func navigateToAuth() {
        navigateToAuthCalled = true
    }
    
    func updateProfileAvatar(url avatarURL: URL) {
        self.avatarURL = avatarURL
    }
    
    func updateProfileDetails(name: String, username: String, bio: String) {
        self.name = name
        self.username = username
        self.bio = bio
    }
}
