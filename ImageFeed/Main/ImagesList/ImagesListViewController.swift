import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: - Views
    
    private var tableView: UITableView?
    
    // MARK: - Private Properties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        addTableView()
    }

    // MARK: - Private Methods
    
    private func setView() {
        view.backgroundColor = .ypBlack
    }
    
    private func addTableView() {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        self.tableView = tableView
    }
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
        guard let image = UIImage(named: "MockData/\(photosName[indexPath.row])") else { return }
        
        cell.cellImage?.image = image
        cell.dateLabel?.text = dateFormatter.string(from: Date())
        cell.isLiked = indexPath.row % 2 == 0
    }
}

// MARK: - Delegate Extension

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        
        let image = UIImage(named: "MockData/\(photosName[indexPath.row])")
        singleImageViewController.image = image
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: "MockData/\(photosName[indexPath.row])") else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
