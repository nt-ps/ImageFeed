import Foundation

final class ProfileService {
    // MARK: - Static Properties
    
    static let shared = ProfileService()
    
    // MARK: - Internal Properties
    
    private(set) var profile: Profile?
    
    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastToken != token else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        
        guard let request = makeUserProfileRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(
            for: request,
            decoder: SnakeCaseJSONDecoder(),
            completion: { [weak self] (result: Result<ProfileResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success(let data):
                        let profile = Profile(from: data)
                        ProfileService.shared.profile = profile
                        completion(.success(profile))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.task = nil
                    self.lastToken = nil
                }
            })
        
        self.task = task
        task.resume()
    }
    
    func reset() {
        profile = nil
    }
    
    // MARK: - Private Methods
    
    private func makeUserProfileRequest(token: String) -> URLRequest? {
        guard var url = Constants.defaultBaseURL else {
            print("[\(#function)] Failed to get URL.")
            return nil
        }
        url = url.appendingPathComponent("me")
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
