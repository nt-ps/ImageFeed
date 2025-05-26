import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
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
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
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
        
        fetchNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func show(error model: ErrorViewModel) {
        let alertModel = AlertModel(from: model)
        alertPresenter?.show(alert: alertModel)
    }
    
    // MARK: - Private Methods
    
    private func fetchNextPage(){
        imagesListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("[\(#function)] Failed to load photos page: \(error.localizedDescription).")
                
                let errorViewModel = ErrorViewModel(
                    message: "Попробовать ещё раз?",
                    buttonText: AlertButtonTitle.again
                ) { [weak self] in
                    self?.fetchNextPage()
                }
                
                self?.show(error: errorViewModel)
            }
        }
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
            fetchNextPage()
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        cell.imageURL = URL(string: photo.thumbImageURL)
        cell.date = photo.createdAt
        cell.isLiked = photo.isLiked
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
        let index = indexPath.row
        let photo = photos[index]
        let newLikeValue = !photo.isLiked
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLiked: newLikeValue) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success:
                self.photos[index] = imagesListService.photos[index]
                cell.isLiked = newLikeValue
            case .failure(let error):
                print("[\(#function)] Failed to change like: \(error.localizedDescription).")
                
                let errorViewModel = ErrorViewModel(
                    message: "Попробовать ещё раз?",
                    buttonText: AlertButtonTitle.again
                ) { [weak self] in
                    self?.imageListCellDidTapLike(cell)
                }
                
                self.show(error: errorViewModel)
            }
        }
    }
    
    private func changeLike() {
        
    }
}

// MARK: - Alert Presenter Delegate Extension

extension ImagesListViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}
