//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alfa on 26.03.2026.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func didReceiveNewPhotos(oldCount: Int, newCount: Int)
    func didPhotoLikeChange(by index: Int)
}

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        presenter?.viewDidLoad()
    }
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let settings = presenter?.getCellSettings(by: indexPath.row) else {
            return
        }
        
        cell.configure(with: settings)
        cell.delegate = self
    }

    private func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func didReceiveNewPhotos(oldCount: Int, newCount: Int) {
        let rows = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        
        if oldCount == 0 {
            tableView.reloadData()
            return
        }
        
        tableView.performBatchUpdates {
            self.tableView.insertRows(at: rows, with: .automatic)
        }
    }
    
    func didPhotoLikeChange(by index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount ?? 0
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
            let presenter,
            indexPath.row == presenter.photosCount - 1,
            offsetY + viewHeight + cellHeight >= contentHeight
        else {
            return
        }

        presenter.loadNewPhotos()
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(by: indexPath.row) else {
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
                let photo = presenter?.getPhoto(by: indexPath.row)
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
        guard let index = tableView.indexPath(for: cell)?.row else {
            return
        }

        presenter?.likePhoto(by: index)
    }
}
