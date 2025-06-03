import Foundation
import CoreGraphics

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    public init(
        id: String = "",
        size: CGSize = CGSize.zero,
        createdAt: Date? = nil,
        welcomeDescription: String? = nil,
        thumbImageURL: String = "",
        largeImageURL: String = "",
        isLiked: Bool = false
    ) {
        self.id = id
        self.size = size
        self.createdAt = createdAt
        self.welcomeDescription = welcomeDescription
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
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
