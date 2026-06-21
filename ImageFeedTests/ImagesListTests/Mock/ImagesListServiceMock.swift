//
//  ImagesListServiceMock.swift
//  ImageFeed
//
//  Created by Nikler on 6/22/26.
//

@testable import ImageFeed
import Foundation

final class ImagesListServiceMock: ImagesListServiceProtocol {
    private let notificationCenter: NotificationCenter
    private let helper = ImagesListTestHelper()

    var photos = [Photo]()
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func fetchPhotosNextPage(showLoading: Bool) {
        let notificationName = AppNotification.newPhotosDidLoad.name
        
        photos += [Photo].init(repeating: helper.photo, count: 10)
        notificationCenter.post(name: notificationName, object: nil)
    }
    
    func cleanPhotos() {
        let notificationName = AppNotification.newPhotosDidLoad.name

        photos = []
        notificationCenter.post(name: notificationName, object: nil)
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        showLoading: Bool,
        completion: @escaping Completion<EmptyResponse>
    ) {
        let photoIndex = photos.firstIndex { $0.id == photoId }!

        photos[photoIndex].isLiked = isLike
        
        completion(.success(EmptyResponse()))
    }
}
