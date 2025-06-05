import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - Internal Properties
    
    var presenter: ImagesListPresenterProtocol?
    
    // MARK: - Views
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: tableViewVerticalInsets, left: 0, bottom: tableViewVerticalInsets, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        return tableView
    } ()
    
    // MARK: - UI Properties
    
    private let tableViewVerticalInsets: Double = 12
    private let imageInsets = UIEdgeInsets(
        top: ImagesListCell.containerViewVerticalMargin,
        left: ImagesListCell.containerViewHorizontalMargin,
        bottom: ImagesListCell.containerViewVerticalMargin,
        right: ImagesListCell.containerViewHorizontalMargin
    )
    
    // MARK: - Private Properties
    
    private var photos: [Photo] = []
    
    // MARK: - Alert
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        view.addSubviews(tableView)
        setConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        alertPresenter = AlertPresenter(delegate: self)
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - UI Updates
    
    func updateTableViewAnimated(from newPhotos: [Photo]) {
        let oldCount = photos.count
        let newCount = newPhotos.count
        photos = newPhotos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func show(error model: ErrorViewModel) {
        let alertModel = AlertModel(from: model)
        alertPresenter?.show(alert: alertModel)
    }
    
    func updatePhoto(with indexPath: IndexPath, from photo: Photo) {
        let index = indexPath.row
        self.photos[index] = photo
        configCell(with: indexPath, from: photo)
    }
    
    func showProgress() {
        UIBlockingProgressHUD.show()
    }
    
    func hideProgress() {
        UIBlockingProgressHUD.dismiss()
    }
    
    private func configCell(with indexPath: IndexPath, from photo: Photo) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        configCell(cell, from: photo)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        configCell(cell, from: photo)
    }
    
    private func configCell(_ cell: ImagesListCell, from photo: Photo) {
        cell.imageURL = URL(string: photo.thumbImageURL)
        cell.date = photo.createdAt
        cell.isLiked = photo.isLiked
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: - Data Source Extension

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            presenter?.fetchNextPage()
        }
    }
}

// MARK: - Delegate Extension

extension ImagesListViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let imageListCell = tableView.cellForRow(at: indexPath) as? ImagesListCell,
            let preview = imageListCell.image
        else { return }
        
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.setImage(from: photos[indexPath.row], placeholder: preview)
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let photo = photos[indexPath.row]
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

// MARK: - Images List Cell Delegate Extension

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.switchLike(with: indexPath)
    }
}

// MARK: - Alert Presenter Delegate Extension

extension ImagesListViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}
