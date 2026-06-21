//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

import Foundation

protocol ImagesListServiceProtocol: AnyObject {
    typealias Completion<T> = ApiRequests.Completion<T>
    
    var photos: [Photo] { get }

    func fetchPhotosNextPage(showLoading: Bool)
    func cleanPhotos()
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        showLoading: Bool,
        completion: @escaping Completion<EmptyResponse>
    )
}

final class ImagesListService: ImagesListServiceProtocol {
    static let shared = ImagesListService()
    
    private let networkClient: NetworkClientProtocol
    private let notificationCenter: NotificationCenter = .default
    private let loadingService: LoadingService = .shared
    
    private(set) var photos = [Photo]()

    private var lastLoadedPage: Int = 0
    
    private init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }
    
    func fetchPhotosNextPage(showLoading: Bool = true) {
        let notificationName = AppNotification.newPhotosDidLoad.name
        let nextPage = lastLoadedPage + 1
        let request = ApiRequests.fetchPhotos(page: nextPage, perPage: 10) {
            if case let .success(photos) = $0 {
                self.photos.append(contentsOf: photos.map(Photo.init))
                self.lastLoadedPage = nextPage
                self.notificationCenter.post(name: notificationName, object: self)
            }
            
            if (showLoading) {
                self.loadingService.hideProgress()
            }
        }
        
        networkClient.get(with: request)
        
        if (showLoading) {
            loadingService.showProgress()
        }
    }
    
    func cleanPhotos() {
        let notificationName = AppNotification.newPhotosDidLoad.name

        photos = []
        lastLoadedPage = 0
        notificationCenter.post(name: notificationName, object: self)
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        showLoading: Bool = true,
        completion: @escaping Completion<EmptyResponse>
    ) {
        let request = ApiRequests.likePhoto(by: photoId) { [weak self] result in
            if case .success = result {
                self?.updatePhotoLike(photoId: photoId, isLiked: isLike)
            }
            
            if (showLoading) {
                self?.loadingService.hideProgress()
            }
            
            completion(result)
        }
        
        if isLike {
            networkClient.post(with: request)
        } else {
            networkClient.delete(with: request)
        }
        
        if (showLoading) {
            loadingService.showProgress()
        }
    }
    
    private func updatePhotoLike(photoId: String, isLiked: Bool) {
        guard let photoIndex = (photos.firstIndex { $0.id == photoId }) else {
            return
        }
        
        photos[photoIndex].isLiked = isLiked
    }
}
