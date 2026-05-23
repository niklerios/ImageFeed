//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Alfa on 26.03.2026.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )

        // todo: кажется делегат уже проставляется автоматически исходя из конфига в Info.plist
        // настройка: Delegate Class Name -> $(PRODUCT_MODULE_NAME).SceneDelegate
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}

