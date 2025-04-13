import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Views
    
    private var logoImageView: UIImageView?
    private var loginButton: UIButton?
    
    // MARK: - Private Properties
    
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        setBackButton()
        addLogo()
        addLoginButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination")
                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    @objc
    private func loginButtonTap() {
        performSegue(withIdentifier: showWebViewSegueIdentifier, sender: loginButton)
    }
    
    private func setView() {
        view.backgroundColor = .ypBlack
    }
    
    private func setBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackwardButtonIcon")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackwardButtonIcon")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    private func addLogo() {
        let logoImageView = UIImageView()
        
        logoImageView.image = UIImage(imageLiteralResourceName: "UnsplashLogo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        self.logoImageView = logoImageView
    }
    
    private func addLoginButton() {
        let loginButton = UIButton(type: .custom)
        
        loginButton.backgroundColor = .ypWhite
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        loginButton.addTarget(self, action: #selector(self.loginButtonTap), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -124)
        ])
        
        self.loginButton = loginButton
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
