//
//  ImagesListPresenterSpy.swift
//  ImageFeed
//
//  Created by Nikler on 6/22/26.
//

@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    var viewDidLoadCallsCount = 0
    
    var photosCount = 0
    
    func viewDidLoad() {
        viewDidLoadCallsCount += 1
    }
    
    func getPhoto(by index: Int) -> ImageFeed.Photo? {
        nil
    }
    
    func getCellSettings(by index: Int) -> ImageFeed.ImagesListCellSettings? {
        nil
    }
    
    func loadNewPhotos() {}
    
    func likePhoto(by index: Int) {}
}
