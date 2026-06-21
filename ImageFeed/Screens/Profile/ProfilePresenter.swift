//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func refreshProfile()
    func logout()
}

final class ProfilePresenter {
    private let profileLogoutService: ProfileLogoutServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol

    weak var view: ProfileViewControllerProtocol?
    
    init(
        profileLogoutService: ProfileLogoutServiceProtocol,
        profileService: ProfileServiceProtocol,
        profileImageService: ProfileImageServiceProtocol,
    ) {
        self.profileLogoutService = profileLogoutService
        self.profileService = profileService
        self.profileImageService = profileImageService
    }
    
    private func refreshProfileAvatar() {
        guard
            let urlString = profileImageService.avatarURLString,
            let url = URL(string: urlString)
        else {
            return
        }
        
        view?.updateProfileAvatar(url: url)
    }
    
    private func refreshProfileDetails() {
        guard let profile = profileService.profile else {
            return
        }
        
        view?.updateProfileDetails(
            name: profile.name,
            username: "@\(profile.username)",
            bio: profile.bio ?? ""
        )
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func refreshProfile() {
        refreshProfileAvatar()
        refreshProfileDetails()
    }

    func logout() {
        profileLogoutService.logout { [weak self] in
            self?.view?.navigateToAuth()
        }
    }
}
