import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(from newPhotos: [Photo])
    func show(error model: ErrorViewModel)
    func updatePhoto(with indexPath: IndexPath, from photo: Photo)
    func showProgress()
    func hideProgress()
}
