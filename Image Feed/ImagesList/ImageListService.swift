import UIKit

final class ImageListService {
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImageListService()
    private init(){}
    private let urlSession = URLSession.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var page: String?
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private let dateFormatter = DateFormatter()
    var lastLoadedPage: Int?
    
    func fetchPhotosNextPage(token: String) {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        
        let nextPage = lastLoadedPage == nil
            ? 1
            : lastLoadedPage! + 1
        
        let request = makeRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    for photo in photoResult {
                        self.photos.append(self.convert(model: photo))
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(name: ImageListService.DidChangeNotification,
                              object: self,
                              userInfo: ["Images" : self.photos])
                    
                case .failure(let error):
                    assertionFailure("receiving image failed, \(error)")
                }
                self.task = nil
                
            }
        }
        self.task = task
        task.resume()
        
        
    }
            
    
    func convert(model: PhotoResult) -> Photo {
        return Photo(id: model.id,
                     size: CGSize(width: model.width, height: model.height),
                     createdAt: model.createdAt ?? "",
                     welcomeDescription: model.description,
                     thumbImageURL: model.urls.thumb,
                     largeImageURL: model.urls.full,
                     isLiked: model.isLiked)
    }
    
    
    func makeRequest(token: String) -> URLRequest {
        var components = URLComponents(string: "https://api.unsplash.com/photos")
        components?.queryItems = [URLQueryItem(name: "page", value: page),
                                  URLQueryItem(name: "per_page", value: "10")]
        
        guard let url = components?.url else { fatalError("URL create error") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
        
        }
}

extension ImageListService {
    
    private func object(for request: URLRequest, completion: @escaping (Result<PhotoResult, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { result in
            let response = result.flatMap { data -> Result<PhotoResult, Error> in
                Result { try decoder.decode(PhotoResult.self, from: data) }
                
            }
            completion(response)
        }
    }
}
