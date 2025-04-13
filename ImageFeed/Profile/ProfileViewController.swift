import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Views
    
    private var userpickImageView: UIImageView?
    private var usernameLabel: UILabel?
    private var nicknameLabel: UILabel?
    private var statusLabel: UILabel?
    private var logoutButton: UIButton?
    
    // MARK: - Private Properties
    
    private var mainTopOffset: CGFloat = 32
    private var mainLeadingOffset: CGFloat = 16
    private var mainTrailingOffset: CGFloat = 16
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
        addUserpickImageView()
        addUsernameLabel()
        addNicknameLabel()
        addStatusLabel()
        addLogoutButton()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func logoutButtonTap() { }
    
    private func setView() {
        view.backgroundColor = .ypBlack
    }
    
    private func addUserpickImageView() {
        let userpickImageView = UIImageView()
        
        userpickImageView.image = UIImage(imageLiteralResourceName: "MockUserpick")   // Mock-данные
        userpickImageView.contentMode = .scaleAspectFill
        userpickImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userpickImageView)
        
        NSLayoutConstraint.activate([
            userpickImageView.widthAnchor.constraint(equalToConstant: 70),
            userpickImageView.heightAnchor.constraint(equalTo: userpickImageView.widthAnchor),
            userpickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: mainTopOffset),
            userpickImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: mainLeadingOffset)
        ])
        
        userpickImageView.layer.cornerRadius = userpickImageView.bounds.width / 2
        
        self.userpickImageView = userpickImageView
    }
    
    private func addUsernameLabel() {
        guard let userpickImageView else { return }
        
        let usernameLabel = UILabel()
        
        usernameLabel.text = "Екатерина Новикова"   // Mock-данные
        usernameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        usernameLabel.textColor = .ypWhite
        usernameLabel.setCharacterSpacing(0.08)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: userpickImageView.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: mainLeadingOffset),
            usernameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -mainLeadingOffset)
        ])
        
        self.usernameLabel = usernameLabel
    }
    
    private func addNicknameLabel() {
        guard let usernameLabel else { return }
        
        let nicknameLabel = UILabel()
        
        nicknameLabel.text = "@ekaterina_nov"   // Mock-данные
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nicknameLabel.textColor = .ypGray
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: usernameLabel.lastBaselineAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: mainLeadingOffset),
            nicknameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -mainLeadingOffset)
        ])
        
        self.nicknameLabel = nicknameLabel
    }
    
    private func addStatusLabel() {
        guard let nicknameLabel else { return }
        
        let statusLabel = UILabel()
        
        statusLabel.text = "Hello, world!"   // Mock-данные
        statusLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        statusLabel.textColor = .ypWhite
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: mainLeadingOffset),
            statusLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -mainLeadingOffset)
        ])
        
        self.statusLabel = statusLabel
    }
    
    private func addLogoutButton() {
        guard let userpickImageView else { return }
        
        let logoutButton = UIButton(type: .custom)
        
        logoutButton.setImage(UIImage(imageLiteralResourceName: "LogoutButtonIcon"), for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutButtonTap), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: userpickImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -mainTrailingOffset + 2)
        ])
        
        self.logoutButton = logoutButton
    }
}
