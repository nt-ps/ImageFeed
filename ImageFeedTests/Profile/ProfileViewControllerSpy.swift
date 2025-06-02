import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var updateProfileImageCalled = false
    
    var alertTitle = ""
    
    func updateProfileDetails(profile: Profile) {
        updateProfileDetailsCalled = true
    }
    
    func updateProfileImage(url: URL) {
        updateProfileImageCalled = true
    }
    
    // Не тестировал, это больше к UI.
    func switchToSplashViewController() { }
    
    func show(alert model: AlertModel) {
        alertTitle = model.title
    }
}
