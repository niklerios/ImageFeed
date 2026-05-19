//
//  LoadingService.swift
//  ImageFeed
//
//  Created by Alfa on 20.05.2026.
//

import UIKit
import ProgressHUD

protocol LoadingServiceProtocol: AnyObject {
    func showProgress()
    func hideProgress()
}

final class LoadingService: LoadingServiceProtocol {
    static let shared = LoadingService()
    
    private init() {}
    
    func showProgress() {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        ProgressHUD.animate()
    }
    
    func hideProgress() {
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
