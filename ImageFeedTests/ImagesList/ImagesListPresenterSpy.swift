@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    var viewDidLoadCalls = false
    
    func viewDidLoad() {
        viewDidLoadCalls = true
    }
    
    func fetchNextPage() { }
    
    func switchLike(with indexPath: IndexPath) { }
}
