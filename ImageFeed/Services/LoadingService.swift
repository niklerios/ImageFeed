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
    func hideProgress(force: Bool?)
}

final class LoadingService: LoadingServiceProtocol {
    static let shared = LoadingService()
    
    private var activeCount = 0
    
    private init() {
        // В либе ProgressHUD баг скалирования (скейл x1.4 и обратный x1/1.4 применяются к исходному фрейму)
        // из-за чего получаем некорректные размеры
        // используем корректирующий коэффициент для компенсации ошибочной арифмеике в либе
        // подробнее - ProgressHUD/Sources/ProgressHUD - 557 и 560 строки
        ProgressHUD.mediaSize = 25 * 1.4
        ProgressHUD.marginSize = 13 * 1.4
    }
    
    func showProgress() {
        activeCount += 1
        ProgressHUD.animate(interaction: false)
    }
    
    func hideProgress(force: Bool? = false) {
        activeCount -= 1
        
        if activeCount <= 0 || force == true {
            ProgressHUD.dismiss()
            activeCount = 0
        }
    }
}
