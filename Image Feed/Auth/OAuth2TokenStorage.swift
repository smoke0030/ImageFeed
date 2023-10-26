import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage  {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    private let keychain = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychain.string(forKey: tokenKey)
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: tokenKey)
            }
        }
    }
    func removeKey() {
        keychain.removeObject(forKey: tokenKey)
    }
    
}
