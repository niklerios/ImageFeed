//
//  ProfileServiceStub.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed

final class ProfileServiceStub: ProfileServiceProtocol {
    let profile: Profile? = Profile(
        username: "test_username",
        name: "test_name",
        login: "test_login",
        bio: nil
    )
    
    let expectedProfile = Profile(
        username: "@test_username",
        name: "test_name",
        login: "test_login",
        bio: ""
    )
    
    func fetchProfile(completion: @escaping Completion<ImageFeed.Profile>) {}
    func cleanProfile() {}
}
