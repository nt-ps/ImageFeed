struct ImageResponseBody: Decodable {
    
    // MARK: - Internal Properties
    
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let rawURL: String
    let fullURL: String
    let regularURL: String
    let smallURL: String
    let thumbURL: String
    let likedByUser: Bool
    
    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case description = "description"
        case urls = "urls"
        case likedByUser = "liked_by_user"
    }
    
    enum URLsCodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
    
    // MARK: - Initializers
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        description = try? container.decode(String.self, forKey: .description)
        likedByUser = try container.decode(Bool.self, forKey: .likedByUser)
        
        let urlsContainer = try container.nestedContainer(keyedBy: URLsCodingKeys.self, forKey: .urls)
        
        rawURL = try urlsContainer.decode(String.self, forKey: .raw)
        fullURL = try urlsContainer.decode(String.self, forKey: .full)
        regularURL = try urlsContainer.decode(String.self, forKey: .regular)
        smallURL = try urlsContainer.decode(String.self, forKey: .small)
        thumbURL = try urlsContainer.decode(String.self, forKey: .thumb)
    }
}
