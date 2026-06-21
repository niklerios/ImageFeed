//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by Nikler on 6/22/26.
//

@testable import ImageFeed
import XCTest

@MainActor
final class ImagesListTests: XCTestCase {
    let helper = ImagesListTestHelper()
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = helper.imagesListViewController
        let presenter = ImagesListPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        XCTAssertEqual(presenter.viewDidLoadCallsCount, 0)
        
        let _ = viewController.view
        
        XCTAssertEqual(presenter.viewDidLoadCallsCount, 1)
    }
    
    func testPresenterCallsDidReceiveNewPhotos() {
        let viewController = ImagesListViewControllerSpy()
        let imagesListService = ImagesListServiceMock(notificationCenter: .default)
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        XCTAssertEqual(viewController.didReceiveNewPhotosCallsCount, 0)
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(viewController.didReceiveNewPhotosCallsCount, 1)
    }
    
    func testPresenterCallsDidPhotoLikeChange() {
        let viewController = ImagesListViewControllerSpy()
        let imagesListService = ImagesListServiceMock(notificationCenter: .default)
        let presenter = ImagesListPresenter(imagesListService: imagesListService)
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        XCTAssertEqual(viewController.didPhotoLikeChangeCallsCount, 0)
        
        presenter.viewDidLoad()
        presenter.likePhoto(by: 1)
        
        XCTAssertEqual(viewController.didPhotoLikeChangeCallsCount, 1)
        XCTAssertEqual(viewController.likedPhotoIndex, 1)
    }
}
