import Foundation

public protocol ProfileImageServiceProtocol {
    static var shared: ProfileImageServiceProtocol { get }
    
    var didChangeNotification: Notification.Name { get }
    var avatarURL: String? { get }
    
    func fetchProfileImageURL(_ token: String, username: String, completion: @escaping (Result<String, Error>) -> Void)
    func reset() 
}
