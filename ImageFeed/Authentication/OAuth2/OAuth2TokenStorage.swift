import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Internal Properties
    
    static var token: String? { storage.string(forKey: Keys.accessToken.rawValue) }
    
    // MARK: - Private Properties
    
    private static let storage: UserDefaults = .standard
    
    // MARK: - Private Enumerations
    
    private enum Keys: String {
        case accessToken
    }
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Internal Methods
    
    static func save(_ token: String) {
        storage.set(token, forKey: Keys.accessToken.rawValue)
    }
}
