import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let description: String?
    let urls: Urls
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case description
        case urls
        case isLiked = "liked_by_user"
        
        
    }
}

struct Urls: Codable {
    let full, thumb: String
}
