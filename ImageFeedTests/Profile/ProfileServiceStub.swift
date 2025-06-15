@testable import ImageFeed
import Foundation

final class ProfileServiceStub : ProfileServiceProtocol {
    static var shared: ProfileServiceStub = ProfileServiceStub()
    
    var profile: Profile? = Profile()
    
    private init() { }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, any Error>) -> Void) { }
    func reset() { }
}
