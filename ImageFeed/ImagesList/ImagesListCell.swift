import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var dateView: UIView!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet private weak var likeButton: UIButton!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradientLayer = CAGradientLayer()
    
    private var likeValue: Bool = false
    public var like: Bool {
        get { likeValue }
        set {
            likeValue = newValue
            likeButton.setImage(
                UIImage(imageLiteralResourceName: likeValue ? "LikeButton/Active" : "LikeButton/NoActive"),
                for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Фон ячейки
        backgroundColor = .clear
         
        // Скругление.
        // Контейнер введен для того, чтобы содержимое ячейки обрезалось с учетом скруглений,
        // при этом отступы между ячейками были сохранены.
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 16
         
        // Установка шрифтов.
        dateLabel.font = UIFont(name: "YandexSansDisplay-Regular", size: 13) ?? nil
         
        // Установка градиента.
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 2.0)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.ypBlack.cgColor]
        dateView.layer.insertSublayer(gradientLayer, at: 0)
         
        // Установка тени.
        likeButton.layer.shadowColor = UIColor.ypBlack.cgColor
        likeButton.layer.shadowOpacity = 0.1
        likeButton.layer.shadowRadius = 4
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        // Обновление размера градиента (сделано так, потому что
        // градиент не хотел прилегать к правой границе View).
        gradientLayer.frame = dateView.bounds
    }
}
