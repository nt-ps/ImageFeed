import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool    
}

extension Photo {
    private static let dateFormatter = ISO8601DateFormatter()
    
    init(from data: ImageResponseBody) {
        id = data.id
        size = CGSize(width: data.width, height: data.height)
        createdAt = Photo.dateFormatter.date(from: data.createdAt)
        welcomeDescription = data.description
        thumbImageURL = data.thumbURL
        largeImageURL = data.fullURL
        isLiked = data.likedByUser
    }
}
