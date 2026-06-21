//
//  ProfileLogoutServiceStub.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

@testable import ImageFeed

final class ProfileLogoutServiceStub: ProfileLogoutServiceProtocol {
    func logout(_ completion: () -> Void) {
        completion()
    }
}
