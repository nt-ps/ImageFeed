import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func fetchNextPage()
    func switchLike(with indexPath: IndexPath)
}
