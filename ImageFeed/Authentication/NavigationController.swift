import UIKit
 
final class NavigationController: UINavigationController {
    
    var authViewController: AuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.backgroundColor = .ypWhite
        
        authViewController = AuthViewController()
        guard let authViewController else { return }
        self.viewControllers = [authViewController]
    }
}
