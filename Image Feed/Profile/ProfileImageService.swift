import UIKit
import Kingfisher

final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    private let profileService = ProfileService.shared
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request = makeRequest(token: token)
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatarURL = body.profileImage.medium
                self.avatarURL = avatarURL
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(name: ProfileImageService.DidChangeNotification,
                          object: self)
            case .failure(let error):
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
    
    func makeRequest(token: String) -> URLRequest {
        var request: URLRequest?
        if let username = profileService.profile?.username,
           let url = URL(string: "https://api.unsplash.com/users/" + "\(username)") {
            request = URLRequest(url: url)
            request?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
             assertionFailure("Error of create URL")
        }
        return request!
    }
}

    extension ProfileImageService {
        private func object(for request: URLRequest, comletion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
            return urlSession.data(for: request) { result in
                let response = result.flatMap { data -> Result<UserResult, Error> in
                    Result { try JSONDecoder().decode(UserResult.self, from: data) }
                }
                comletion(response)
            }
        }
    }
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let medium: String
    }


