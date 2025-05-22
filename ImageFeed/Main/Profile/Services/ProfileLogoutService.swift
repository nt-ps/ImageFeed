import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()

    private init() { }

    func logout() {
        cleanCookies()
        resetServices()
        cleanStorage()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func resetServices() {
        ImagesListService.shared.reset()
        ProfileService.shared.reset()
        ProfileImageService.shared.reset()
    }
    
    private func cleanStorage() {
        OAuth2TokenStorage.remove()
    }
}
    
