import Foundation

final class OAuth2TokenStorage {
    
    // MARK: - Internal Properties
    
    var token: String? {
        get { storage.string(forKey: Keys.accessToken.rawValue) }
        set { storage.set(newValue, forKey: Keys.accessToken.rawValue) }
    }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults = .standard
    
    // MARK: - Private Enumerations
    
    private enum Keys: String {
        case accessToken
    }
}
