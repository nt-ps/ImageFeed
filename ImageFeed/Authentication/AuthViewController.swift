import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Views
    
    private var logoImageView: UIImageView?
    private var loginButton: UIButton?
    
    // MARK: - Alert
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter(delegate: self)
        
        setView()
        setBackButton()
        addLogo()
        addLoginButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private Methods
    
    @objc
    private func loginButtonTap() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        webViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(webViewController, animated: true)
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
        
        logoImageView.image = UIImage(named: "UnsplashLogo")
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
    
    private func show(error model: ErrorViewModel) {
        let alertModel = AlertModel(from: model)
        alertPresenter?.show(alert: alertModel)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String) {
        // Вместо "vc: WebViewViewController" и "vc.dismiss" вывожу контроллеры
        // из navigationController до текущего, поскольку иначе почему-то
        // текущий контроллер закрывается и алерт не выводится.
        navigationController?.popToViewController(self, animated: true)

        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.delegate?.didAuthenticate(self, token: token)
            case .failure(let error):
                print("[webViewViewController] Login failed.")
                
                let errorViewModel = ErrorViewModel(message: error.localizedDescription)
                self.show(error: errorViewModel)
            }
        }
    }
}

extension AuthViewController: AlertPresenterDelegate {
    func didReceiveAlert(alert: UIAlertController?) {
        guard let alert else { return }
        present(alert, animated: true, completion: nil)
    }
}
