import UIKit
import WebKit


final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
        
        updateProgress()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self,
                               forKeyPath: #keyPath(WKWebView.estimatedProgress),
                               context: nil)
        updateProgress()
    }
    
    override func observeValue(forKeyPath keyPath: String?, 
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var components = URLComponents(string: "https://unsplash.com/oauth/authorize")
        components?.queryItems = [URLQueryItem(name: "client_id", value: AccessKey),
                                  URLQueryItem(name: "redirect_uri", value: RedirectURI),
                                  URLQueryItem(name: "response_type", value: "code"),
                                  URLQueryItem(name: "scope", value: AccessScope)]
        if let url = components?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}


extension WebViewViewController: WKNavigationDelegate {
    private func code(from url: URL?) -> String? {
        guard let url = url,
             let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == "/oauth/authorize/native",
              let items = urlComponents.queryItems?.first(where: { $0.value == "code"} ) else { return nil }
           
        return items.value
    }
    
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
}
