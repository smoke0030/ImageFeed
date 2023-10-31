import Foundation

//struct PhotoResult: Decodable{
//    let id: String
//    let createdAt: String?
//    let welcomeDescription: String?
//    let isLiked: Bool?
//    let urls: UrlsResult?
//    let width: CGFloat
//    let height: CGFloat
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case createdAt = "created_at"
//        case welcomeDescription = "description"
//        case isLiked = "liked_by_user"
//        case urls = "urls"
//        case width = "width"
//        case height = "height"
//    }
//}
//
//struct UrlsResult: Decodable {
//    let thumbImageURL: String?
//    let largeImageURL: String?
//
//    enum CodingKeys: String, CodingKey {
//        case thumbImageURL = "thumb"
//        case largeImageURL = "full"
//    }
//}

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
