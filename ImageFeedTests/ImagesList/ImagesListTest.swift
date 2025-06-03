@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalls)
    }
    
    func testPresenterCallsUpdateTableView() {
        let imagesListService = ImagesListServiceStub.shared as! ImagesListServiceStub
        imagesListService.isSuccess = true
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        presenter.fetchNextPage()
            
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
    
    func testPresenterCallsShowError() {
        let imagesListService = ImagesListServiceStub.shared as! ImagesListServiceStub
        imagesListService.isSuccess = false
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        presenter.fetchNextPage()
            
        XCTAssertEqual(viewController.alertMessage, "Попробовать ещё раз?")
    }
    
    func testPresenterCallsUpdatePhoto() {
        let imagesListService = ImagesListServiceStub.shared as! ImagesListServiceStub
        imagesListService.isSuccess = true
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        let indexPath = IndexPath(row: 0, section: 0)
        
        presenter.viewDidLoad()
        presenter.fetchNextPage()
        presenter.switchLike(with: indexPath)
        
        XCTAssertTrue(viewController.updatePhotoCalled)
    }
    
    func testProgressDisplayOrder() {
        let imagesListService = ImagesListServiceStub.shared as! ImagesListServiceStub
        imagesListService.isSuccess = true
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(
            imagesListService: imagesListService
        )
        viewController.presenter = presenter
        presenter.view = viewController
        let indexPath = IndexPath(row: 0, section: 0)
        
        presenter.viewDidLoad()
        presenter.fetchNextPage()
        presenter.switchLike(with: indexPath)
        
        XCTAssertEqual(viewController.progressDisplayOrder, ["show", "hide"])
    }
}
