//
//  ImagesListViewControllerSpy.swift
//  ImageFeed
//
//  Created by Nikler on 6/22/26.
//

@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var didReceiveNewPhotosCallsCount = 0
    var didPhotoLikeChangeCallsCount = 0

    var likedPhotoIndex: Int?
    
    func didReceiveNewPhotos(oldCount: Int, newCount: Int) {
        didReceiveNewPhotosCallsCount += 1
    }
    
    func didPhotoLikeChange(by index: Int) {
        didPhotoLikeChangeCallsCount += 1
        likedPhotoIndex = index
    }
}
