//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alfa on 27.03.2026.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    @IBOutlet private var photoImageView: UIImageView!
    @IBOutlet private var likeButtonView: UIButton!
    @IBOutlet private var dateTextView: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    static let cellMargins: (h: CGFloat, v: CGFloat) = (h: 16, v: 4)

    private let gradientLayer = CAGradientLayer()
    private lazy var placeholder = UIImage(resource: .stub)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame(height: 30)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.kf.cancelDownloadTask()
    }
    
    func configure(with settings: ImagesListCellSettings) {
        let image: UIImage = settings.isLiked
            ? .likeButtonOn
            : .likeButtonOff

        dateTextView.text = settings.dateString
        likeButtonView.setImage(image, for: .normal)
        
        setupViewBeforeImageLoading()
        
        photoImageView.kf.setImage(
            with: settings.imageURL,
            placeholder: placeholder
        ) { [weak self] result in
            if case .success = result {
                self?.setupViewWhenImageLoaded()
            }
        }
    }
    
    private func setupViewBeforeImageLoading() {
        photoImageView.kf.indicatorType = .activity
        photoImageView.contentMode = .center
        likeButtonView.isHidden = true
        dateTextView.isHidden = true

        clearGradient()
    }
    
    private func setupViewWhenImageLoaded() {
        photoImageView.contentMode = .scaleAspectFill
        likeButtonView.isHidden = false
        dateTextView.isHidden = false

        setupGradient()
    }
}

// MARK: - Gradient settings
extension ImagesListCell {
    private func updateGradientFrame(height: CGFloat) {
        let width = photoImageView.bounds.width
        let y = photoImageView.bounds.height - height
        
        gradientLayer.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0).cgColor,
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor
        ]
        gradientLayer.locations = [0, 0.5]
        photoImageView.layer.addSublayer(gradientLayer)
    }

    private func clearGradient() {
        gradientLayer.removeFromSuperlayer()
    }
}
