//
//  TestHelper.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed

struct TestHelper {
    func createPresenterWithServiceStubs(
        profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutServiceStub(),
        profileService: ProfileServiceProtocol = ProfileServiceStub(),
        profileImageService: ProfileImageServiceProtocol = ProfileImageServiceStub()
    ) -> ProfilePresenterProtocol {
        ProfilePresenter(
            profileLogoutService: profileLogoutService,
            profileService: profileService,
            profileImageService: profileImageService
        )
    }
}
