import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfileDetails(profile: Profile)
    func updateProfileImage(url: URL)
    func switchToSplashViewController()
    func show(alert model: AlertModel)
}
