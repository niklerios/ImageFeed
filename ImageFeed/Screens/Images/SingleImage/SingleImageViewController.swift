//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alfa on 18.04.2026.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private var image: UIImage?
    
    var photo: Photo? {
        didSet {
            guard isViewLoaded else { return }
    
            configureImageView()
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var shareButtonView: UIButton!
    @IBOutlet private var imageView: UIImageView!
    
    private let loadingService: LoadingService = .shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScrollView()
        configureImageView()
        configureShareButtonView()
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true ,completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        present(activityViewController, animated: true, completion: nil)
    }

    private func rescaleAndCenterImageInScrollView() {
        guard let image else { return }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale

        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let aspectFillScale = max(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, aspectFillScale))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func centerImageInScrollViewIfNeeded() {
        let scrollSize = scrollView.bounds.size
        let contentSize = scrollView.contentSize
        
        let vInset = max((scrollSize.height - contentSize.height) / 2, 0)
        let hInset = max((scrollSize.width - contentSize.width) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(
            top: vInset,
            left: hInset,
            bottom: vInset,
            right: hInset
        )
    }
    
    private func configureScrollView() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        scrollView.bounces = false
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    private func configureImageView() {
        guard
            let photo,
            let photoUrl = URL(string: photo.largeImageURL)
        else {
            return
        }
        
        loadingService.showProgress()
        
        imageView.kf.setImage(with: photoUrl) { [weak self, loadingService] in
            defer {
                loadingService.hideProgress()
            }

            guard let self else {
                return
            }

            if case let .success(data) = $0 {
                self.image = data.image
                self.rescaleAndCenterImageInScrollView()
            } else {
                self.showError()
            }
        }
    }
    
    private func configureShareButtonView() {
        shareButtonView.layer.cornerRadius = shareButtonView.bounds.height / 2
        shareButtonView.clipsToBounds = true
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.configureImageView()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(repeatAction)
        
        present(alertController, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageInScrollViewIfNeeded()
    }
}
