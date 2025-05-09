import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Segue Identifiers
    
    //private let showAuthViewSegueIdentifier = "ShowAuthView"
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if OAuth2TokenStorage.token != nil {
            switchToTabBarController()
        } else {
            let navigationController = NavigationController()
            navigationController.authViewController?.delegate = self
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func setView() {
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
    
    private func switchToTabBarController() {
        if let token = OAuth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            print("Failed to get token.")
        }
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration.")
            return
        }
        //let tabBarController = UIStoryboard(name: "Main", bundle: .main)
        //    .instantiateViewController(withIdentifier: "TabBarViewController")
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { result in
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let result):
                let username = result.username
                
                ProfileImageService.shared.fetchProfileImageURL(token, username: username) { result in
                    UIBlockingProgressHUD.dismiss()
                    
                    switch result {
                    case .success:
                        // ***
                        break
                    case .failure:
                        // TODO: Также можно вывести алерт с ошибкой загрузки профиля.
                        break
                    }
                }
                break
            case .failure:
                // TODO: Также можно вывести алерт с ошибкой загрузки профиля.
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            self?.switchToTabBarController()
        }
    }
}
