import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: unsplashLogoName)
        logoImageView.contentMode = .scaleAspectFill
        return logoImageView
    } ()
    
    private lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .custom)
        loginButton.backgroundColor = .ypWhite
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = loginButtonCornerRadius
        loginButton.setTitle(loginButtonTitle, for: .normal)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: loginButtonFontSize, weight: .bold)
        loginButton.addTarget(self, action: #selector(self.loginButtonTap), for: .touchUpInside)
        loginButton.accessibilityIdentifier = "Authenticate"
        return loginButton
    } ()
    
    // MARK: - Internal Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - UI Properties
    
    private let backwardButtonIconName: String = "BackwardButtonIcon"
    
    private let unsplashLogoName: String = "UnsplashLogo"
    private let unsplashLogoSize: Double = 60
    
    private let loginButtonHeight: Double = 48
    private let loginButtonTitle: String = "Войти"
    private let loginButtonFontSize: Double = 17
    private let loginButtonCornerRadius: Double = 16
    private let loginButtonMargin: Double = 16
    private let loginButtonBottomOffset: Double = 124
    
    // MARK: - Alert
    
    private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: backwardButtonIconName)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: backwardButtonIconName)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
        
        view.addSubviews(logoImageView, loginButton)
        setConstraints()
        
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: unsplashLogoSize),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loginButton.heightAnchor.constraint(equalToConstant: loginButtonHeight),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginButtonMargin),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginButtonMargin),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -loginButtonBottomOffset)
        ])
    }
    
    private func show(error model: ErrorViewModel) {
        let alertModel = AlertModel(from: model)
        alertPresenter?.show(alert: alertModel)
    }
    
    // MARK: - Button Actions
    
    @objc
    private func loginButtonTap() {
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        let webViewViewController = WebViewViewController()
        
        webViewPresenter.view = webViewViewController
        
        webViewViewController.presenter = webViewPresenter
        webViewViewController.delegate = self
        webViewViewController.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(webViewViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String) {
        navigationController?.popToViewController(self, animated: true)

        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.delegate?.didAuthenticate(self, token: token)
            case .failure(let error):
                print("[\(#function)] Login failed.")
                
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
