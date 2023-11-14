import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL?) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        loadWebView()
    }
    
    func loadWebView() {
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize")
        components?.queryItems = [URLQueryItem(name: "client_id", value: accessKey),
                                  URLQueryItem(name: "redirect_uri", value: redirectURI),
                                  URLQueryItem(name: "response_type", value: "code"),
                                  URLQueryItem(name: "scope", value: accessScope)]
        if let url = components?.url {
            let request = URLRequest(url: url)
            didUpdateProgressValue(0)
            view?.load(request: request)
        }
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) ->  Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL?) -> String? {
        guard let url = url,
              let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == "/oauth/authorize/native",
              let items = urlComponents.queryItems?.first(where: { $0.name == "code"} ) else { return nil }
        return items.value
    }
}
