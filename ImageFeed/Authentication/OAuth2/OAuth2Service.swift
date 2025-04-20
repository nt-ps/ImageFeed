import Foundation

final class OAuth2Service {
    
    // MARK: - Static Properties
    
    static let shared = OAuth2Service()
    
    // MARK: - Private Enumeration
    
    private enum OAuth2ServiceError: Error {
        case invalidURL
    }
    
    // MARK: - Private Properties
    
    private let tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(OAuth2ServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self?.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody))
                } catch {
                    print("JSON decoder error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("URL session error: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            print("Failed to initialize URL components.")
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
            print("Failed to get URL.")
            return nil
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
