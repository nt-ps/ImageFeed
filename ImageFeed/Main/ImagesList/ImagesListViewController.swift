import UIKit

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
        right: ImagesListCell.containerViewHorizontalMargin)
    
    // MARK: - Private Properties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    private let currentDate = Date()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        view.addSubviews(tableView)
        setConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
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
    
    // MARK: - Private Methods
    
    private func getImageName(for index: Int) -> String { "MockData/\(photosName[index])" }
}

// MARK: - Data Source Extension

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
                
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: getImageName(for: indexPath.row)) else { return }
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        cell.isLiked = indexPath.row % 2 == 0
    }
}

// MARK: - Delegate Extension

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        
        let image = UIImage(named: getImageName(for: indexPath.row))
        singleImageViewController.image = image
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: getImageName(for: indexPath.row)) else {
            return 0
        }
        
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
