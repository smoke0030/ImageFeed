import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func ViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}
