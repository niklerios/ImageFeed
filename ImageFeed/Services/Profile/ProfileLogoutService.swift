//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Nikler on 6/14/26.
//

import Foundation
import WebKit

protocol ProfileLogoutServiceProtocol: AnyObject {
    func logout(_ completion: () -> Void)
}

final class ProfileLogoutService: ProfileLogoutServiceProtocol {
    static let shared = ProfileLogoutService()
    
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private let imagesListService: ImagesImageListServiceProtocol
    private let oAuth2Service: OAuth2ServiceProtocol
    
    private init(
        profileService: ProfileServiceProtocol = ProfileService.shared,
        profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
        imagesListService: ImagesImageListServiceProtocol = ImagesListService.shared,
        oAuth2Service: OAuth2ServiceProtocol = OAuth2Service.shared
    ) {
        self.profileService = profileService
        self.profileImageService = profileImageService
        self.imagesListService = imagesListService
        self.oAuth2Service = oAuth2Service
    }
    
    func logout(_ completion: () -> Void) {
        cleanCookies()
        
        profileService.cleanProfile()
        profileImageService.cleanAvatar()
        imagesListService.cleanPhotos()
        oAuth2Service.cleanToken()
        
        completion()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore
            .default()
            .fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                records.forEach {
                    WKWebsiteDataStore.default().removeData(
                        ofTypes: $0.dataTypes,
                        for: [$0],
                        completionHandler: {}
                    )
                }
            }
    }
}
