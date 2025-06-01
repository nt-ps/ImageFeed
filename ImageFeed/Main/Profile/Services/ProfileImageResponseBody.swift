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
        case small, medium, large
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let profileImageContainer = try container.nestedContainer(
            keyedBy: ProfileImageCodingKeys.self,
            forKey: .profileImage
        )
        small = try profileImageContainer.decode(String.self, forKey: .small)
        medium = try profileImageContainer.decode(String.self, forKey: .medium)
        large = try profileImageContainer.decode(String.self, forKey: .large)
    }
}
