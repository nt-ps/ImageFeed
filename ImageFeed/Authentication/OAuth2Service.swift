import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let storage: OAuth2TokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else { return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else { return nil }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            print("Failed to generate OAuth token request.")
            completion(.failure(OAuth2ServiceError.invalidURL))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self?.storage.token = responseBody.accessToken
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
}

enum OAuth2ServiceError: Error {
    case invalidURL
}
