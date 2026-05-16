//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alfa on 18.04.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            
            configureImageView()
            rescaleAndCenterImageInScrollView()
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var shareButtonView: UIButton!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScrollView()
        configureImageView()
        configureShareButtonView()

        rescaleAndCenterImageInScrollView()
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
        guard let image else { return }
        
        imageView.image = image
        imageView.frame.size = image.size
    }
    
    private func configureShareButtonView() {
        shareButtonView.layer.cornerRadius = shareButtonView.bounds.height / 2
        shareButtonView.clipsToBounds = true
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
