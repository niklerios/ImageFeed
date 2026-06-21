//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed
import XCTest

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

@MainActor
final class ProfileTests: XCTestCase {
    let helper = TestHelper()

    func testViewControllerCallsRefreshProfile() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        let _ = viewController.view
        
        XCTAssertTrue(presenter.refreshProfileCalled)
    }
    
    func testPresenterCallsNavigateToAuth() {
        let viewController = ProfileViewControllerSpy()
        let presenter = helper.createPresenterWithServiceStubs()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.logout()
        
        XCTAssertTrue(viewController.navigateToAuthCalled)
    }
    
    func testPresenterCallsUpdateProfileAvatarAndDetails() {
        let profileImageService = ProfileImageServiceStub()
        let profileService = ProfileServiceStub()
        
        let viewController = ProfileViewControllerSpy()
        let presenter = helper.createPresenterWithServiceStubs(
            profileService: profileService,
            profileImageService: profileImageService
        )
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.refreshProfile()
        
        let profile = profileService.expectedProfile
        let avatarURL = profileImageService.expectedAvatarURL
        
        XCTAssertEqual(viewController.avatarURL, avatarURL)
        XCTAssertEqual(viewController.name, profile.name)
        XCTAssertEqual(viewController.username, profile.username)
        XCTAssertEqual(viewController.bio, profile.bio)
    }
}
