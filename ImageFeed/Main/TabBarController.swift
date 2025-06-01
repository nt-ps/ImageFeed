import UIKit
 
final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlack
        appearance.stackedLayoutAppearance.selected.iconColor = .ypWhite
        self.tabBar.standardAppearance = appearance
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
           title: "",
           image: UIImage(named: "MainButtonIcon"),
           selectedImage: nil
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
           title: "",
           image: UIImage(named: "ProfileButtonIcon"),
           selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
