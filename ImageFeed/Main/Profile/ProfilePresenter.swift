import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        guard let profile = ProfileService.shared.profile else { return }
        view?.updateProfileDetails(profile: profile)

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateProfileImage()
            }
        updateProfileImage()
    }
    
    func logout() {
        let model = AlertModel(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            actionButton: AlertButton(title: AlertButtonTitle.yes) { [weak self] in
                guard let self else { return }
                ProfileLogoutService.shared.logout()
                self.view?.switchToSplashViewController()
            },
            cancelButton: AlertButton(title: AlertButtonTitle.no, action: nil)
        )
        
        view?.show(alert: model)
    }
    
    private func updateProfileImage() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        view?.updateProfileImage(url: url)
    }
}
