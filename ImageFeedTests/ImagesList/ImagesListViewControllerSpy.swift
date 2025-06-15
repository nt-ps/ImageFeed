@testable import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var updateTableViewAnimatedCalled = false
    var updatePhotoCalled = false
    var alertMessage = ""
    var progressDisplayOrder: [String] = []
    
    func updateTableViewAnimated(from newPhotos: [Photo]) {
        updateTableViewAnimatedCalled = true
    }
    
    func show(error model: ErrorViewModel) {
        alertMessage = model.message
    }
    
    func updatePhoto(with indexPath: IndexPath, from photo: Photo) {
        updatePhotoCalled = true
    }
    
    func showProgress() {
        progressDisplayOrder.append("show")
    }
    
    func hideProgress() {
        progressDisplayOrder.append("hide")
    }
}
