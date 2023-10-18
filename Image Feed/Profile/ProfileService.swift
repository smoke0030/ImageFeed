//
//  ProfileService.swift
//  Image Feed
//
//  Created by Сергей on 16.10.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        let request =  makeRequest(token: token)
        
        
        let task = object(for: request) { [weak self] (result: Result<ProfileResult, Error>)  in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(data: body)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        
        
        
    }
        
        
        func makeRequest(token: String) -> URLRequest {
            guard let url = URL(string: "https://api.unsplash.com" + "/me") else { fatalError("Error of create URL") }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
        
        
        
        
        func object(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.profileData(for: request) { result in
                let response = result.flatMap { data -> Result<ProfileResult, Error> in
                    Result { try decoder.decode(ProfileResult.self, from: data) }
                }
                print(response)
                completion(response)
            }
        }
    }
    
extension URLSession {
    func profileData(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                    print("DATA", data)
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
    

struct ProfileResult: Codable {
    
    let id: String
    let username, name, firstName, lastName: String
    let bio: String?
    let profileImage: ProfileImage?
    
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage
    }
}


struct Profile: Codable {
    let id: String
    let username: String
    let name:String
    let loginName: String
    let bio: String?
    let profileImage: ProfileImage?
    
    init(data: ProfileResult) {
        self.id = data.id
        self.username = data.username
        self.name = (data.firstName) + " " + (data.lastName)
        self.loginName = "@" + data.username
        self.bio =  data.bio
        self.profileImage = data.profileImage
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}
