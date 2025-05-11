import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Views
    
    private var profileImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var bioLabel: UILabel?
    private var logoutButton: UIButton?
    
    // MARK: - Private Properties
    
    private let mainTopOffset: CGFloat = 32
    private let mainLeadingOffset: CGFloat = 16
    private let mainTrailingOffset: CGFloat = 16
    
    private let profileImageSize: Double = 70
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let imageCache = ImageCache.default
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache()
        
        setView()
        
        addProfileImageView()
        addNameLabel()
        addLoginNameLabel()
        addBioLabel()
        addLogoutButton()
        
        guard let profile = ProfileService.shared.profile else { return }
        updateProfileDetails(profile: profile)

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateProfileImage()
            }
        updateProfileImage()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func logoutButtonTap() { }
    
    private func setView() {
        view.backgroundColor = .ypBlack
    }
    
    private func addProfileImageView() {
        let profileImageView = UIImageView()
        
        profileImageView.image = UIImage(named: "ProfileImageStub")
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: mainTopOffset
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainLeadingOffset
            )
        ])
        
        self.profileImageView = profileImageView
    }
    
    private func addNameLabel() {
        guard let profileImageView else { return }
        
        let nameLabel = UILabel()
        
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.setCharacterSpacing(0.08)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainLeadingOffset
            ),
            nameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainLeadingOffset
            )
        ])
        
        self.nameLabel = nameLabel
    }
    
    private func addLoginNameLabel() {
        guard let nameLabel else { return }
        
        let loginNameLabel = UILabel()
        
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = .ypGray
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainLeadingOffset
            ),
            loginNameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainLeadingOffset
            )
        ])
        
        self.loginNameLabel = loginNameLabel
    }
    
    private func addBioLabel() {
        guard let loginNameLabel else { return }
        
        let bioLabel = UILabel()
        
        bioLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        bioLabel.textColor = .ypWhite
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(bioLabel)
        
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainLeadingOffset
            ),
            bioLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainLeadingOffset
            )
        ])
        
        self.bioLabel = bioLabel
    }
    
    private func addLogoutButton() {
        guard let profileImageView else { return }
        
        let logoutButton = UIButton(type: .custom)
        
        logoutButton.setImage(UIImage(named: "LogoutButtonIcon"), for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutButtonTap), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainTrailingOffset + 2
            )
        ])
        
        self.logoutButton = logoutButton
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel?.text = profile.name
        loginNameLabel?.text = profile.loginName
        bioLabel?.text = profile.bio
    }
    
    private func updateProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let profileImageView
        else { return }
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "ProfileImageStub")
        )
        profileImageView.layer.cornerRadius = profileImageSize / 2
        profileImageView.layer.masksToBounds = true
    }
}
