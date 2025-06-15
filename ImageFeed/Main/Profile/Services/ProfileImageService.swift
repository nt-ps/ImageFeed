import Foundation

final class ProfileImageService: ProfileImageServiceProtocol {
    
    // MARK: - Static Properties
    
    static var shared: ProfileImageService = ProfileImageService()
    
    // MARK: - Internal Properties
    
    var didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    var avatarURL: String? { avatarURLValue }
    
    // MARK: - Private Properties

    private var avatarURLValue: String?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private var lastUsername: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchProfileImageURL(_ token: String, username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard
            lastToken != token,
            lastUsername != username
        else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        lastUsername = username
        
        guard let request = makePublicProfileRequest(token: token, username: username) else {
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(
            for: request,
            decoder: JSONDecoder(),
            completion: { [weak self] (result: Result<ProfileImageResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success(let data):
                        let avatarURL = data.small
                        self.avatarURLValue = avatarURL
                        NotificationCenter.default.post(
                            name: self.didChangeNotification,
                            object: self,
                            userInfo: ["URL": avatarURL]
                        )
                        completion(.success(avatarURL))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.task = nil
                    self.lastToken = nil
                    self.lastUsername = nil
                }
            })
        
        self.task = task
        task.resume()
    }
    
    func reset() {
        avatarURLValue = nil
        
        task?.cancel()
        task = nil
    
        lastToken = nil
        lastUsername = nil
    }
    
    // MARK: - Private Methods
    
    private func makePublicProfileRequest(token: String, username: String) -> URLRequest? {
        guard var url = Constants.defaultBaseURL else {
            print("[\(#function)] Failed to get URL.")
            return nil
        }
        url = url.appendingPathComponent("users/\(username)")
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
