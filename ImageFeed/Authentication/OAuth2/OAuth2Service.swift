import Foundation

final class OAuth2Service {
    
    // MARK: - Static Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Properties

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuth2ServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(
            for: request,
            decoder: SnakeCaseJSONDecoder(),
            completion: { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    switch result {
                    case .success(let data):
                        let token: String = data.accessToken
                        OAuth2TokenStorage.token = token
                        completion(.success(token))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    self.task = nil
                    self.lastCode = nil
                }
            })
        
        self.task = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("[\(#function)] Failed to initialize URL components.")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("[\(#function)] Failed to get URL.")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post
        return request
    }
}
