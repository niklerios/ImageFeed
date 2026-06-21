//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Nikler on 6/21/26.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    var photosCount: Int { get }
    
    func viewDidLoad()
    func getPhoto(by index: Int) -> Photo?
    func getCellSettings(by index: Int) -> ImagesListCellSettings?
    func loadNewPhotos()
    func likePhoto(by index: Int)
}

final class ImagesListPresenter {
    weak var view: ImagesListViewControllerProtocol?
    
    private let notificationCenter: NotificationCenter = .default
    private let imagesListService: ImagesListServiceProtocol

    private var newPhotosDidLoadObserver: NSObjectProtocol?
    
    private var photos = [Photo]()
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    deinit {
        if let newPhotosDidLoadObserver {
            notificationCenter.removeObserver(newPhotosDidLoadObserver)
        }
    }
    
    private func observeNewPhotosDidLoad() {
        newPhotosDidLoadObserver = notificationCenter.addObserver(
            forName: AppNotification.newPhotosDidLoad.name,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.didReceiveNewPhotos()
        }
    }
    
    private func didReceiveNewPhotos() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        guard newCount > 0 else { return }
        
        syncPhotosWithImageListService()
        
        view?.didReceiveNewPhotos(
            oldCount: oldCount,
            newCount: newCount
        )
    }
    
    private func didPhotoLikeChange(by index: Int) {
        syncPhotosWithImageListService()
        view?.didPhotoLikeChange(by: index)
    }
    
    private func syncPhotosWithImageListService() {
        photos = imagesListService.photos
    }
}

extension ImagesListPresenter: ImagesListPresenterProtocol {
    var photosCount: Int { photos.count }
    
    func viewDidLoad() {
        loadNewPhotos()
        observeNewPhotosDidLoad()
    }
    
    func loadNewPhotos() {
        imagesListService.fetchPhotosNextPage(showLoading: true)
    }
    
    func getPhoto(by index: Int) -> Photo? {
        photos[safe: index]
    }
    
    func getCellSettings(by index: Int) -> ImagesListCellSettings? {
        guard
            let photo = getPhoto(by: index),
            let photoURL = URL(string: photo.smallImageURL)
        else {
            return nil
        }
        
        return ImagesListCellSettings(
            imageURL: photoURL,
            isLiked: photo.isLiked,
            date: photo.createdAt ?? Date()
        )
    }
    
    func likePhoto(by index: Int) {
        guard let photo = getPhoto(by: index) else {
            return
        }
        
        let isLiked = !photo.isLiked
        
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: isLiked,
            showLoading: true
        ) { [weak self] result in
            if case .success = result {
                self?.didPhotoLikeChange(by: index)
            }
        }
    }
}
