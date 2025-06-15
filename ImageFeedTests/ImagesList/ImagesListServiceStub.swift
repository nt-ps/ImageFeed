@testable import ImageFeed
import Foundation

final class ImagesListServiceStub: ImagesListServiceProtocol {
    static var shared: ImagesListServiceStub = ImagesListServiceStub()
    
    var isSuccess = true
    var didChangeNotification = Notification.Name("ImagesListServiceStub")
    var photos: [Photo] { photosValue }
    
    private var photosValue: [Photo] = []
    
    enum ImagesListServiceStubError: Error {
        case justError
    }
    
    private init() { }
    
    func fetchPhotosNextPage(completion: @escaping (Result<Int, any Error>) -> Void) {
        switch isSuccess{
        case true:
            photosValue.append(Photo())
            NotificationCenter.default.post(
                name: self.didChangeNotification,
                object: self
            )
            completion(.success(0))
        case false:
            completion(.failure(ImagesListServiceStubError.justError))
        }
    }
    
    func changeLike(
        photoId: String,
        isLiked: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        switch isSuccess{
        case true:
            NotificationCenter.default.post(
                name: self.didChangeNotification,
                object: self
            )
            completion(.success(()))
        case false:
            completion(.failure(ImagesListServiceStubError.justError))
        }
    }
    
    func reset() { }
}
