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
    
    private init() {
        // В либе ProgressHUD баг скалирования (скейл x1.4 и обратный x1/1.4 применяются к исходному фрейму)
        // из-за чего получаем некорректные размеры
        // используем корректирующий коэффициент для компенсации ошибочной арифмеике в либе
        // подробнее - ProgressHUD/Sources/ProgressHUD - 557 и 560 строки
        ProgressHUD.mediaSize = 25 * 1.4
        ProgressHUD.marginSize = 13 * 1.4
    }
    
    func showProgress() {
        // Альтернатива - дизейблить window ,но мне показалось логичнее использовать вшитый механизм в либу
        // UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        ProgressHUD.animate(interaction: false)
    }
    
    func hideProgress() {
        // UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
