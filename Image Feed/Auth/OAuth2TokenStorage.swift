import Foundation


class OAuth2TokenStorage  {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    private let userDefaults = UserDefaults()
    
    var token: String? {
        get {
            userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.setValue(newValue, forKey: tokenKey)
        }
    }
}
