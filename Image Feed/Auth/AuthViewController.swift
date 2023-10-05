import UIKit

class AuthViewController: UIViewController {
    private let identifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                fatalError("Failed to prepare for \(identifier)") }
            webViewViewController.delegate = self
        }
            else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }

extension AuthViewController: WebViewViewControllerDelegate {
    func ViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
