//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

import Foundation

protocol ImagesImageListServiceProtocol: AnyObject {
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesImageListServiceProtocol {
    static let shared = ImagesListService()
    
    private let networkClient: NetworkClientProtocol
    private let notificationCenter: NotificationCenter = .default
    
    private(set) var photos = [Photo]()
    private var lastLoadedPage: Int = 0
    
    private init(networkClient: NetworkClientProtocol = NetworkClient.shared) {
        self.networkClient = networkClient
    }
    
    func fetchPhotosNextPage() {
        let notificationName = AppNotification.newPhotosDidLoad.name
        let nextPage = lastLoadedPage + 1
        let request = ApiRequests.fetchPhotos(page: nextPage, perPage: 10) {
            if case let .success(photos) = $0 {
                self.photos.append(contentsOf: photos.map(Photo.init))
                self.lastLoadedPage = nextPage
                self.notificationCenter.post(name: notificationName, object: self)
            }
        }
        
        networkClient.get(with: request)
    }
}
