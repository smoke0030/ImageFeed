import Foundation

let AccessKey = "l3cbbKpfPKOYkdmMI2sl8r2pA4h4zCcjAGDCcxn4sjA"
let SecretKey = "GCTPWxV4tGgHYfxVPsCfEmgmLfFODL9jH5nxsSD37jY"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope =  "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://unsplash.com")!
let DefaultBaseApiURL = URL(string: "https://api.unsplash.com")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let defaultBaseApiURL: URL
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, defaultBaseApiURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.defaultBaseApiURL = defaultBaseApiURL
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 defaultBaseApiURL: DefaultBaseApiURL)
    }
}
