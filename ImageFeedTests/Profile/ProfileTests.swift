@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
            
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateProfileDetails() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileServiceStub.shared,
            profileImageService: ProfileImageServiceStub.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()

        XCTAssertTrue(viewController.updateProfileDetailsCalled)
    }
    
    func testPresenterCallsUpdateProfileImage() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileServiceStub.shared,
            profileImageService: ProfileImageServiceStub.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.updateProfileImageCalled)
    }
    
    func testPresenterCallsShow() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenter(
            profileService: ProfileServiceStub.shared,
            profileImageService: ProfileImageServiceStub.shared
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.logout()
        
        XCTAssertEqual("Пока, пока!", viewController.alertTitle)
    }
}
