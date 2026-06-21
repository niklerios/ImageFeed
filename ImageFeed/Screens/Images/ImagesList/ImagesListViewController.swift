//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alfa on 26.03.2026.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService: ImagesListService = .shared
    private let notificationCenter: NotificationCenter = .default
    
    private var newPhotosDidLoadObserver: NSObjectProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"

    private var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        loadNewPhotos()
        observeNewPhotosDidLoad()
    }
    
    deinit {
        if let newPhotosDidLoadObserver {
            notificationCenter.removeObserver(newPhotosDidLoadObserver)
        }
    }
    
    private func observeNewPhotosDidLoad() {
        newPhotosDidLoadObserver = notificationCenter.addObserver(
            forName: AppNotification.newPhotosDidLoad.name,
            object: imagesListService,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewWithNewPhotos()
        }
    }
    
    private func loadNewPhotos() {
        imagesListService.fetchPhotosNextPage(showLoading: true)
    }
    
    private func updateTableViewWithNewPhotos() {
        let photosCount = photos.count
        let newPhotos = imagesListService.photos
        
        guard newPhotos.count > 0 else {
            photos = newPhotos
            tableView.reloadData()
            
            return
        }
        
        let range = (photosCount..<newPhotos.count)
        let rows = range.map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates {
            self.photos = newPhotos
            self.tableView.insertRows(at: rows, with: .automatic)
        }
    }
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard
            let photo = getPhoto(by: indexPath.row),
            let photoURL = URL(string: photo.smallImageURL)
        else {
            return
        }
        
        let settings = ImagesListCellSettings(
            imageURL: photoURL,
            isLiked: photo.isLiked,
            date: photo.createdAt ?? Date()
        )
        
        cell.configure(with: settings)
        cell.delegate = self
    }
    
    private func getPhoto(by index: Int) -> Photo? {
        photos[safe: index]
    }

    private func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func syncPhotos() {
        photos = imagesListService.photos
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imagesListCell = cell as? ImagesListCell else {
            assertionFailure("Failed to cast cell to \(ImagesListCell.self)")
            return UITableViewCell()
        }
        
        configureCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let offsetY = tableView.contentOffset.y
        let viewHeight = tableView.bounds.height
        let contentHeight = tableView.contentSize.height
        let cellHeight = cell.bounds.height
        
        guard
            indexPath.row == photos.count - 1,
            offsetY + viewHeight + cellHeight >= contentHeight
        else {
            return
        }

        loadNewPhotos()
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = getPhoto(by: indexPath.row) else {
            return 200
        }
        
        let margins = (
            v: ImagesListCell.cellMargins.v * 2,
            h: ImagesListCell.cellMargins.h * 2,
        )

        let photoWidth = photo.size.width
        let photoHeight = photo.size.height
        let viewWidth = tableView.bounds.width - margins.h
        
        return photoHeight / photoWidth * viewWidth + margins.v
    }
}

// MARK: - Preparing for segues
extension ImagesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let photo = getPhoto(by: indexPath.row)
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard
            let indexPath = tableView.indexPath(for: cell),
            let photo = getPhoto(by: indexPath.row)
        else {
            return
        }
        
        let isLiked = !photo.isLiked
        
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: isLiked
        ) { [weak self] result in
            if case .success = result {
                self?.syncPhotos()
                cell.setIsLiked(isLiked)
            }
        }
    }
}
