import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Segue Identifiers
    
    private let showAuthViewSegueIdentifier = "ShowAuthView"
    
    // MARK: - Private Properties
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - Overrides Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthViewSegueIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Failed to prepare for \(showAuthViewSegueIdentifier)")
            }

            authViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration.") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, withCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
                switch result {
                case .success:
                    self?.switchToTabBarController()
                case .failure:
                    print("Login failed.")
                    // TODO: Показать алерт.
                }
            }
        }
    }
}
