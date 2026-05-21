//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alfa on 11.04.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private let profileService: ProfileService = .shared
    private let profileImageService: ProfileImageService = .shared
    private let notificationCenter: NotificationCenter = .default
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let baseFontSize: CGFloat = 13
    private let userAvatarSize: CGFloat = 70

    private lazy var defaultAvatarImage = UIImage(systemName: "person.crop.circle.fill")
    
    private lazy var userDescriptionLabel = createLabel(
        withText: "Профиль не заполнен",
        font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
    )

    private lazy var userIdLabel = createLabel(
        withText: "@неизвестный_пользователь",
        font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular),
        color: .ypGray
    )

    private lazy var userNameLabel = createLabel(
        withText: "Имя не указано",
        font: UIFont.systemFont(ofSize: 23, weight: .bold)
    )

    private lazy var logoutButton = createLogoutButton()
    private lazy var userAvatarImageView = createUserAvatarImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupSubviews()

        updateProfileAvatar()
        updateProfileDetails()

        observeProfileImageService()
    }
    
    private func observeProfileImageService() {
        profileImageServiceObserver = notificationCenter.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: profileImageService,
            queue: .main
        ) { [weak self] _ in
            self?.updateProfileAvatar()
        }
    }

    @objc private func didTapLogoutButton(_ sender: UIButton) {
        print("Exit")
    }
}

// MARK: - UI Settings
extension ProfileViewController {
    private func setupUI() {
        view.backgroundColor = .ypBlack
    }
    
    private func setupSubviews() {
        view.addSubview(userAvatarImageView)
        view.addSubview(userDescriptionLabel)
        view.addSubview(userIdLabel)
        view.addSubview(userNameLabel)
        view.addSubview(logoutButton)
        
        setupSubviewsConstraints()
    }
    
    private func updateProfileAvatar() {
        guard
            let avatarURLString = profileImageService.avatarURLString,
            let avatarURL = URL(string: avatarURLString)
        else {
            return
        }
        
        let radius = userAvatarSize / 2
        let processor = RoundCornerImageProcessor(cornerRadius: radius)
        
        userAvatarImageView.kf.setImage(
            with: avatarURL,
            placeholder: defaultAvatarImage,
            options: [
                .processor(processor),
                .transition(.fade(0.3))
            ]
        )
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            return
        }
        
        if !profile.name.isEmpty {
            userNameLabel.text = profile.name
        }
        if !profile.username.isEmpty {
            userIdLabel.text = "@\(profile.username)"
        }
        if let bio = profile.bio, !bio.isEmpty {
            userDescriptionLabel.text = bio
        }
    }
    
    private func createUserAvatarImageView() -> UIImageView {
        let imageView = UIImageView(image: defaultAvatarImage)
        
        imageView.tintColor = .ypGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func createLogoutButton() -> UIButton {
        let button = UIButton.systemButton(
            with: .logoutButton,
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypRed
        
        return button
    }
    
    private func createLabel(
        withText text: String,
        font: UIFont,
        color: UIColor = .ypWhite
    ) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.font = font
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func setupSubviewsConstraints() {
        let topInset: CGFloat = 32
        let hInset: CGFloat = 24
        let labelSpacing: CGFloat = 8

        NSLayoutConstraint.activate([
            // userAvatarImageView
            userAvatarImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: topInset
            ),
            userAvatarImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: hInset
            ),
            userAvatarImageView.widthAnchor.constraint(
                equalToConstant: userAvatarSize
            ),
            userAvatarImageView.heightAnchor.constraint(
                equalToConstant: userAvatarSize
            ),

            // logoutButton
            logoutButton.centerYAnchor.constraint(
                equalTo: userAvatarImageView.centerYAnchor
            ),
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -hInset
            ),

            // userNameLabel
            userNameLabel.leadingAnchor.constraint(
                equalTo: userAvatarImageView.leadingAnchor
            ),
            userNameLabel.topAnchor.constraint(
                equalTo: userAvatarImageView.bottomAnchor,
                constant: labelSpacing
            ),

            // userIdLabel
            userIdLabel.leadingAnchor.constraint(
                equalTo: userAvatarImageView.leadingAnchor
            ),
            userIdLabel.topAnchor.constraint(
                equalTo: userNameLabel.bottomAnchor,
                constant: labelSpacing
            ),

            // userDescriptionLabel
            userDescriptionLabel.leadingAnchor.constraint(
                equalTo: userAvatarImageView.leadingAnchor
            ),
            userDescriptionLabel.topAnchor.constraint(
                equalTo: userIdLabel.bottomAnchor,
                constant: labelSpacing
            )
            
        ])
    }
}
