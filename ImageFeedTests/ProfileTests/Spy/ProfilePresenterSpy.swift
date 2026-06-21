//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var refreshProfileCalled = false
    var logoutCalled = false

    var view: ProfileViewControllerProtocol?
    
    func refreshProfile() {
        refreshProfileCalled = true
    }
    
    func logout() {}
}
