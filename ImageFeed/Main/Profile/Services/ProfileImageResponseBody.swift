import Foundation

struct ProfileImageResponseBody: Decodable {

    // MARK: - Internal Properties
    
    let small: String
    let medium: String
    let large: String
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    enum ProfileImageCodingKeys: String, CodingKey {
        case small
        case medium
        case large
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let profileImageContainer = try container.nestedContainer(keyedBy: ProfileImageCodingKeys.self, forKey: .profileImage)
        self.small = try profileImageContainer.decode(String.self, forKey: .small)
        self.medium = try profileImageContainer.decode(String.self, forKey: .medium)
        self.large = try profileImageContainer.decode(String.self, forKey: .large)
    }
}
