//
//  ImagesListTestHelper.swift
//  ImageFeed
//
//  Created by Nikler on 6/22/26.
//

@testable import ImageFeed
import UIKit

struct ImagesListTestHelper {
    var photo: Photo {
        Photo(
            id: "test_id",
            size: CGSize(width: 100, height: 100),
            createdAt: Date(),
            welcomeDescription: "welcome_test",
            thumbImageURL: "https://thumb-image.test",
            smallImageURL: "https://small-image.test",
            largeImageURL: "https://large-image.test",
            isLiked: false
        )
    }

    var imagesListViewController: ImagesListViewController {
        UIStoryboard.viewController(ImagesListViewController.self)!
    }
}
