import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        fetchNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: imagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                let photos = ImagesListService.shared.photos
                self?.view?.updateTableViewAnimated(from: photos)
            }
    }
    
    func fetchNextPage() {
        imagesListService.fetchPhotosNextPage() { [weak self] result in
            switch result {
            case .success:
                break
            case .failure(let error):
                print("[\(#function)] Failed to load photos page: \(error.localizedDescription).")
                
                let errorViewModel = ErrorViewModel(
                    message: "Попробовать ещё раз?",
                    buttonText: AlertButtonTitle.again
                ) { [weak self] in
                    self?.fetchNextPage()
                }
                
                self?.view?.show(error: errorViewModel)
            }
        }
    }
    
    func switchLike(with indexPath: IndexPath) {
        let index = indexPath.row
        let photo = imagesListService.photos[index]
        let newLikeValue = !photo.isLiked
        
        view?.showProgress()
        
        imagesListService.changeLike(photoId: photo.id, isLiked: newLikeValue) { [weak self] result in
            guard let self else { return }
            
            self.view?.hideProgress()
            
            switch result {
            case .success:
                let photo = imagesListService.photos[index]
                self.view?.updatePhoto(with: indexPath, from: photo)
            case .failure(let error):
                print("[\(#function)] Failed to change like: \(error.localizedDescription).")
                
                let errorViewModel = ErrorViewModel(
                    message: "Попробовать ещё раз?",
                    buttonText: AlertButtonTitle.again
                ) { [weak self] in
                    self?.switchLike(with: indexPath)
                }
                
                self.view?.show(error: errorViewModel)
            }
        }
    }
}
