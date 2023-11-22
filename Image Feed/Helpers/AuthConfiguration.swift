import Foundation

let AccessKey = "0qsdZp_QW5_FMfaFpCYk2S0MIH-hGN4p8BpNL7KTjXY"
let SecretKey = "gtFxPJ9s2giLrgIRhL4p40EftWeHumPGuMX29-u7ZTo"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope =  "public+read_user+write_likes"

let AuthURLString = "https://unsplash.com/oauth/authorize"
let DefaultBaseURL = URL(string: "https://unsplash.com")!
let DefaultBaseApiURL = URL(string: "https://api.unsplash.com")!

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: URL
    let defaultBaseApiURL: URL
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, defaultBaseApiURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.authURLString = authURLString
        self.defaultBaseURL = defaultBaseURL
        self.defaultBaseApiURL = defaultBaseApiURL
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: AuthURLString,
                                 defaultBaseURL: DefaultBaseURL,
                                 defaultBaseApiURL: DefaultBaseApiURL)
    }
}
