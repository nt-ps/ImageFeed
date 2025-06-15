import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    // MARK: - Internal Properties
    
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Views
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: profileImageName)
        profileImageView.contentMode = .scaleAspectFill
        return profileImageView
    } ()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: bigFontSize, weight: .bold)
        nameLabel.textColor = .ypWhite
        nameLabel.setCharacterSpacing(0.08)
        return nameLabel
    } ()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.font = UIFont.systemFont(ofSize: smallFontSize, weight: .regular)
        loginNameLabel.textColor = .ypGray
        return loginNameLabel
    } ()
    
    private lazy var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.font = UIFont.systemFont(ofSize: smallFontSize, weight: .regular)
        bioLabel.textColor = .ypWhite
        return bioLabel
    } ()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(UIImage(named: logoutButtonIconName), for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutButtonTap), for: .touchUpInside)
        logoutButton.accessibilityIdentifier = Identifiers.profileLogoutButtom
        return logoutButton
    } ()
    
    // MARK: - UI Properties
    
    private let mainTopOffset: CGFloat = 32
    private let mainHorizontalOffset: CGFloat = 16
    
    private let profileImageName: String = "ProfileImageStub"
    private let profileImageSize: Double = 70
    
    private let bigFontSize: Double = 23
    private let smallFontSize: Double = 13
    
    private let logoutButtonIconName: String = "LogoutButtonIcon"
    private let logoutButtonSize: Double = 44
    
    // MARK: - Alert
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        view.addSubviews(profileImageView, nameLabel, loginNameLabel, bioLabel, logoutButton)
        setConstraints()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        presenter?.viewDidLoad()
    }
    
    // MARK: - Button Actions
    
    @objc
    private func logoutButtonTap() {
        presenter?.logout()
    }
    
    // MARK: - UI Updates
    
    func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        bioLabel.text = profile.bio
    }
    
    func updateProfileImage(url: URL) {        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: profileImageName)
        )
        profileImageView.layer.cornerRadius = profileImageSize / 2
        profileImageView.layer.masksToBounds = true
    }
    
    func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("[\(#function)] Invalid Configuration.")
            return
        }

        window.rootViewController = SplashViewController()
    }
    
    func show(alert model: AlertModel) {
        alertPresenter?.show(alert: model)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            profileImageView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: mainTopOffset
            ),
            profileImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainHorizontalOffset
            ),
            
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: mainHorizontalOffset / 2),
            nameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainHorizontalOffset
            ),
            nameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainHorizontalOffset
            ),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.lastBaselineAnchor, constant: mainHorizontalOffset / 2),
            loginNameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainHorizontalOffset
            ),
            loginNameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainHorizontalOffset
            ),
            
            bioLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: mainHorizontalOffset / 2),
            bioLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: mainHorizontalOffset
            ),
            bioLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainHorizontalOffset
            ),
            
            logoutButton.widthAnchor.constraint(equalToConstant: logoutButtonSize),
            logoutButton.heightAnchor.constraint(equalTo: logoutButton.widthAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -mainHorizontalOffset + 2
            )
        ])
    }
}

extension ProfileViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}
