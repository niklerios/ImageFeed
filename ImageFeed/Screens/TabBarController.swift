//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Alfa on 22.05.2026.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let imagesListViewController = makeImagesListViewController()
        let profileViewController = makeProfileViewController()
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
    
    private func makeImagesListViewController() -> UIViewController {
        UIStoryboard.abstractViewController(ImagesListViewController.self)
    }
    
    private func makeProfileViewController() -> ProfileViewController {
        let controller = ProfileViewController()
        
        let presenter = ProfilePresenter(
            profileLogoutService: ProfileLogoutService.shared,
            profileService: ProfileService.shared,
            profileImageService: ProfileImageService.shared
        )
        
        controller.presenter = presenter
        presenter.view = controller
        
        controller.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        return controller
    }
}
