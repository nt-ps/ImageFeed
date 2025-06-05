import ImageFeed
import Foundation

final class ProfileServiceStub : ProfileServiceProtocol {
    static var shared: ProfileServiceStub = ProfileServiceStub()
    
    var profile: ImageFeed.Profile? = ImageFeed.Profile()
    
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) { }
    func reset() { }
}
