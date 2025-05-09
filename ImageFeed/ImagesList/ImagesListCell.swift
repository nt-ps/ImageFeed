import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Views
    
    var cellImage: UIImageView?
    var dateLabel: UILabel?
    
    private var containerView: UIView?
    private var likeButton: UIButton?
    
    // MARK: - Static Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Internal Properties
    
    var isLiked: Bool {
        get { likeValue }
        set {
            likeValue = newValue
            guard let likeImage = UIImage(named: likeValue ? "LikeButtonIcon/Active" : "LikeButtonIcon/NoActive") else { return }
            likeButton?.setImage(likeImage, for: .normal)
        }
    }
    
    // MARK: - Private Properties
    
    private var likeValue: Bool = false
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
        addContainer()
        addImage()
        addLikeButton()
        addGradient()
        addDateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setView() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func addContainer() {
        let containerView = UIView()
        
        containerView.backgroundColor = .ypWhite
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        self.containerView = containerView
    }
    
    private func addImage() {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView?.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.cellImage = imageView
    }
    
    private func addLikeButton() {
        let likeButton = UIButton(type: .custom)
        
        likeButton.setImage(UIImage(named: "LikeButtonIcon/NoActive"), for: .normal)
        likeButton.layer.shadowColor = UIColor.ypBlack.cgColor
        likeButton.layer.shadowOpacity = 0.1
        likeButton.layer.shadowRadius = 4
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        guard let containerView else { return }
        
        containerView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor),
            likeButton.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        self.likeButton = likeButton
    }
    
    private func addGradient() {
        let gradient = UIImageView()
        
        gradient.image = UIImage(named: "DarkGradientBackground")
        gradient.contentMode = .scaleToFill
        gradient.translatesAutoresizingMaskIntoConstraints = false
        
        guard let containerView else { return }
        
        containerView.addSubview(gradient)
        
        NSLayoutConstraint.activate([
            gradient.heightAnchor.constraint(equalToConstant: 30),
            gradient.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            gradient.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            gradient.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func addDateLabel() {
        let dateLabel = UILabel()
        
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .ypWhite
        dateLabel.setCharacterSpacing(0.08)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard let containerView else { return }
        
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: containerView.trailingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        self.dateLabel = dateLabel
    }
}
