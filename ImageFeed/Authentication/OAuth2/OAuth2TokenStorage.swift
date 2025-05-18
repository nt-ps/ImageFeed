import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static var token: String? {
        get { storage.string(forKey: Keys.accessToken.rawValue) }
        set {
            guard let newValue else { return }
            storage.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }

    private static let storage: KeychainWrapper = .standard
    
    private enum Keys: String {
        case accessToken
    }
}
