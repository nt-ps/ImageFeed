import Foundation

final class ImagesListService {
    // MARK: - Static Properties
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Internal Properties
    
    private(set) var photos: [Photo] = []
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    
    private lazy var mainURL: URL? = {
        guard var url = Constants.defaultBaseURL else {
            return nil
        }
        url = url.appendingPathComponent("photos")
        return url
    }()
    
    private let perPage: Int = 10
    private var lastLoadedPage: Int = 0
    
    private var task: URLSessionTask?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<Int, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            completion(.failure(ImagesListServiceError.tooManyRequests))
            return
        }
        
        let currentPageNumber = lastLoadedPage + 1
        
        guard let request = makePhotosListRequest(token: token, pageNumber: currentPageNumber) else {
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
                        data.forEach { self.photos.append(Photo(from: $0)) }
                        self.lastLoadedPage = currentPageNumber
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            //userInfo: ["URL": avatarURL]
                        )
                        completion(.success(self.photos.count))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.task = nil
                }
            })
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makePhotosListRequest(token: String, pageNumber: Int) -> URLRequest? {
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
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
