//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Alfa on 11.04.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileService: ProfileService = .shared
    
    private let baseFontSize: CGFloat = 13
    
    private lazy var userDescriptionLabel = createLabel(
        withText: "Hello, World!",
        font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
    )

    private lazy var userIdLabel = createLabel(
        withText: "@ekaterina_nov",
        font: UIFont.systemFont(ofSize: baseFontSize, weight: .regular),
        color: .ypGray
    )

    private lazy var userNameLabel = createLabel(
        withText: "Екатерина Новикова",
        font: UIFont.systemFont(ofSize: 23, weight: .bold)
    )

    private lazy var logoutButton = createLogoutButton()
    private lazy var userAvatarImageView = createUserAvatarImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupSubviews()

        updateProfileDetails()
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
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else {
            return
        }
        
        userNameLabel.text = profile.name
        userIdLabel.text = "@\(profile.username)"
        userDescriptionLabel.text = profile.bio
    }
    
    private func createUserAvatarImageView() -> UIImageView {
        let image = UIImage(resource: .avatarExample)
        let imageView = UIImageView(image: image)
        
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
        let avatarSize: CGFloat = 70
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
                equalToConstant: avatarSize
            ),
            userAvatarImageView.heightAnchor.constraint(
                equalToConstant: avatarSize
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
