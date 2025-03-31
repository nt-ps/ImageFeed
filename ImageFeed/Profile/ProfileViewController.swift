import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var userPickImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Настройка элементов экрана.
        userPickImageView.layer.cornerRadius = userPickImageView.bounds.width / 2
        userNameLabel.setCharacterSpacing(0.08)
    }
    
    // MARK: - IB Actions
    
    @IBAction private func logoutButtonTap(_ sender: Any) { }
}
