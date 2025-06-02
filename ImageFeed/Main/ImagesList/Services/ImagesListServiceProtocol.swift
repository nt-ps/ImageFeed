import Foundation

public protocol ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol { get }
    
    var didChangeNotification: Notification.Name { get }
    var photos: [Photo] { get }
    
    func fetchPhotosNextPage(completion: @escaping (Result<Int, Error>) -> Void)
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) 
    func reset()
}
