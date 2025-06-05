import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = cellImageContentMode
        return imageView
    } ()
    
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: dateLabelFontSize, weight: .regular)
        dateLabel.textColor = .ypWhite
        dateLabel.setCharacterSpacing(0.08)
        return dateLabel
    } ()
    
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .ypWhiteA50
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = containerViewCornerRadius
        return containerView
    } ()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton(type: .custom)
        likeButton.setImage(UIImage(named: likeButtonNoActiveIcon), for: .normal)
        likeButton.layer.shadowColor = UIColor.ypBlack.cgColor
        likeButton.layer.shadowOpacity = 0.1
        likeButton.layer.shadowRadius = 4
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        likeButton.addTarget(self, action: #selector(self.likeButtonTap), for: .touchUpInside)
        likeButton.accessibilityIdentifier = "LikeButton"
        return likeButton
    } ()
    
    private lazy var gradient: UIImageView = {
        let gradient = UIImageView()
        gradient.image = UIImage(named: gradientImageName)
        gradient.contentMode = .scaleToFill
        return gradient
    } ()
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    } ()
    
    // MARK: - Internal Properties
    
    weak var delegate: ImagesListCellDelegate?
    
    var image: UIImage? { cellImage.image }
    
    var imageURL: URL? {
        didSet (oldURL) {
            guard
                let imageURL,
                imageURL != oldURL
            else { return }
            
            cellImage.kf.cancelDownloadTask()
            
            cellImage.contentMode = .center
            cellImage.kf.indicatorType = .none
            cellImage.kf.setImage(
                with: imageURL,
                placeholder: cellImagePlaceholder,
                completionHandler: { [weak self] result in
                    guard let self else { return }
                    self.cellImage.contentMode = self.cellImageContentMode
                }
            )
        }
    }
    
    var date: Date? {
        didSet (oldDate) {
            if let date {
                if date != oldDate {
                    dateLabel.text = ImagesListCell.dateFormatter.string(from: date)
                }
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    var isLiked: Bool? {
        didSet (oldValue) {
            guard
                let isLiked,
                isLiked != oldValue
            else { return }
            
            let imageName = isLiked ? likeButtonActiveIcon : likeButtonNoActiveIcon
            guard let likeImage = UIImage(named: imageName) else { return }
            likeButton.setImage(likeImage, for: .normal)
        }
    }
    
    // MARK: - UI Properties
    
    static let containerViewVerticalMargin: Double = 4
    static let containerViewHorizontalMargin: Double = 16
    private let containerViewCornerRadius: Double = 16
    
    private let cellImageMinHeight: Double = 30
    private let cellImagePlaceholder: UIImage? = UIImage(named: "ImageStub")
    private let cellImageContentMode: ContentMode = .scaleAspectFit
    
    private let likeButtonSize: Double = 44
    private let likeButtonActiveIcon: String = "LikeButtonIcon/Active"
    private let likeButtonNoActiveIcon: String = "LikeButtonIcon/NoActive"
    
    private let gradientImageName: String = "DarkGradientBackground"
    private let gradientImageHeight: Double = 30
    
    private let dateLabelMargin: Double = 8
    private let dateLabelFontSize: Double = 13
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.addSubviews(cellImage, gradient, dateLabel)
        addSubviews(containerView)
        contentView.addSubviews(likeButton)
        setConstraints()
        
        isLiked = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("ImagesListCell.init(coder:) has not been implemented")
    }
    
    // MARK: - Overrided methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func likeButtonTap() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: ImagesListCell.containerViewVerticalMargin
            ),
            containerView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -ImagesListCell.containerViewVerticalMargin
            ),
            containerView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: ImagesListCell.containerViewHorizontalMargin
            ),
            containerView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -ImagesListCell.containerViewHorizontalMargin
            ),
            
            cellImage.topAnchor.constraint(equalTo: self.topAnchor),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cellImage.heightAnchor.constraint(equalToConstant: cellImageMinHeight),
            
            likeButton.widthAnchor.constraint(equalToConstant: likeButtonSize),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            gradient.heightAnchor.constraint(equalToConstant: gradientImageHeight),
            gradient.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradient.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            dateLabel.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: dateLabelMargin
            ),
            dateLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: containerView.trailingAnchor,
                constant: dateLabelMargin
            ),
            dateLabel.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -dateLabelMargin
            )
        ])
    }
}
