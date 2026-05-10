//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alfa on 26.03.2026.
//

import UIKit

// MARK: - ImagesListViewController

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName: [String] = (0..<20).map { "\($0)" }
    
    private let today = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = getPhoto(by: indexPath.row) else {
            return
        }
        
        let settings = ImagesListCellSettings(
            image: photo,
            isLiked: indexPath.row % 2 == 0,
            date: today
        )
        
        cell.configure(with: settings)
    }
    
    private func getPhoto(by index: Int) -> UIImage? {
        guard
            let photoName = photosName[safe: index],
            let photo = UIImage(named: photoName)
        else {
            return nil
        }
        
        return photo
    }

    private func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            assertionFailure("Failed to cast cell to \(ImagesListCell.self)")
            return UITableViewCell()
        }
        
        configureCell(for: imagesListCell, with: indexPath)
        
        return imagesListCell
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
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.image = getPhoto(by: indexPath.row)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
