import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        let logoImageView = UIImageView()
        
        logoImageView.image = UIImage(named: "PracticumLogo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.token{
            switchToTabBarController(token: token)
        } else {
            switchToNavigationController()
        }
    }
    
    // MARK: - UI Updates
    
    private func switchToTabBarController(token: String) {
        fetchProfile(token: token) { 
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("[\(#function)] Invalid Configuration.")
                return
            }

            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
        }
    }
    
    private func switchToNavigationController() {
        let navigationController = NavigationController()
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true) { [weak self] in
            navigationController.authViewController?.delegate = self
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchProfile(token: String, completion: @escaping () -> Void) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { result in
            switch result {
            case .success(let data):
                ProfileImageService.shared.fetchProfileImageURL(token, username: data.username) { result in
                    UIBlockingProgressHUD.dismiss()
                    
                    switch result {
                    case .success:
                        completion()
                    case .failure(let error):
                        print("[\(#function)] Failed to get profile image URL: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("[\(#function)] Failed to get user profile: \(error.localizedDescription)")
                
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, token: String) {
        vc.dismiss(animated: true) { [weak self] in
            self?.switchToTabBarController(token: token)
        }
    }
}
