//
//  ProfileImageServiceStub.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed
import Foundation

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURLString: String? { "https://test.test" }
    
    lazy var expectedAvatarURL = URL(string: avatarURLString!)!
    
    func fetchProfileImageURL(username: String, completion: Completion<String>?) {}
    func cleanAvatar() {}
}
