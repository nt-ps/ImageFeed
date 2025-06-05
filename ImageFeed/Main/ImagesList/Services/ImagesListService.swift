import Foundation

final class ImagesListService: ImagesListServiceProtocol {
    
    // MARK: - Static Properties
    
    static var shared: ImagesListService = ImagesListService()
    
    // MARK: - Internal Properties
    
    var didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    var photos: [Photo] { photosValue }
    
    // MARK: - Private Properties
    
    private var photosValue: [Photo] = []
    
    private let urlSession = URLSession.shared
    
    private lazy var mainURL: URL? = {
        guard var url = Constants.defaultBaseURL else {
            return nil
        }
        url = url.appendingPathComponent("photos")
        return url
    }()
    
    private var photoPageTask: URLSessionTask?
    
    private let perPage: Int = 10
    private var lastLoadedPage: Int = 0
    
    private var likePhotoTasks: [String: URLSessionTask] = [:]
    
    // MARK: - Initializers
    
    private init() { }
    
    // MARK: - Internal Methods
    
    func fetchPhotosNextPage(completion: @escaping (Result<Int, Error>) -> Void) {
        assert(Thread.isMainThread)
        if photoPageTask != nil {
            return
        }
        
        let currentPageNumber = lastLoadedPage + 1
        
        guard let request = makePhotosListRequest(pageNumber: currentPageNumber) else {
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(
            for: request,
            decoder: JSONDecoder(),
            completion: { [weak self] (result: Result<[ImageResponseBody], Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success(let data):
                        let receivedPhotos = data.map { Photo(from: $0) }
                        self.photosValue.append(contentsOf: receivedPhotos)
                        self.lastLoadedPage = currentPageNumber
                        NotificationCenter.default.post(
                            name: self.didChangeNotification,
                            object: self
                        )
                        completion(.success(self.photos.count))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.photoPageTask = nil
                }
            })
        
        self.photoPageTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLiked: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if likePhotoTasks[photoId] != nil {
            completion(.failure(ImagesListServiceError.tooManyRequests))
            return
        }
        
        guard let request = makeLikePhotoRequest(photoId: photoId, isLiked: isLiked) else {
            completion(.failure(ImagesListServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.data(
            for: request,
            completion: { [weak self] (result: Result<Data, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success:
                        if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                            let photo = self.photos[index]
                            self.photosValue[index] = Photo(
                                id: photo.id,
                                size: photo.size,
                                createdAt: photo.createdAt,
                                welcomeDescription: photo.welcomeDescription,
                                thumbImageURL: photo.thumbImageURL,
                                largeImageURL: photo.largeImageURL,
                                isLiked: !photo.isLiked
                            )
                        }
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.likePhotoTasks.removeValue(forKey: photoId)
                }
            })
        
        self.likePhotoTasks[photoId] = task
        task.resume()
    }
    
    func reset() {
        photosValue.removeAll()
        lastLoadedPage = 0
        
        photoPageTask?.cancel()
        photoPageTask = nil

        likePhotoTasks.forEach { $0.value.cancel() }
        likePhotoTasks.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func makePhotosListRequest(pageNumber: Int) -> URLRequest? {
        guard
            let mainURL,
            var urlComponents = URLComponents(url: mainURL, resolvingAgainstBaseURL: true)
        else {
            print("[\(#function)] Failed to initialize URL components.")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        
        guard let url = urlComponents.url else {
            print("[\(#function)] Failed to get URL.")
            return nil
        }
        
        guard let token = OAuth2TokenStorage.token else {
            print("[\(#function)] Failed to get OAuth2 token.")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func makeLikePhotoRequest(photoId: String, isLiked: Bool) -> URLRequest? {
        guard var url = mainURL else {
            print("[\(#function)] Failed to initialize URL components.")
            return nil
        }
        
        url = url.appendingPathComponent(photoId)
        url = url.appendingPathComponent("like")
        
        guard let token = OAuth2TokenStorage.token else {
            print("[\(#function)] Failed to get OAuth2 token.")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = isLiked ? HTTPMethod.post : HTTPMethod.delete
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
