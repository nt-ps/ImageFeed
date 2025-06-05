import ImageFeed
import Foundation

final class ProfileImageServiceStub : ProfileImageServiceProtocol {
    var didChangeNotification = Notification.Name("ProfileImageServiceStub")
    var avatarURL: String? = "https://api.unsplash.com/"
    
    static var shared: ProfileImageServiceStub = ProfileImageServiceStub()

    private init() {}
    
    func fetchProfileImageURL(_ token: String, username: String, completion: @escaping (Result<String, any Error>) -> Void) { }
    func reset() { }
}
