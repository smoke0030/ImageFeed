//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Чупрыненко on 01.10.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (oauth2TokenStorage.token != nil) {
            guard let token = oauth2TokenStorage.token else { return }
//            fetchProfile(token: token)
            print("TOKEN", token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        print("CODE", code)
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            
            
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                ProgressHUD.dismiss()
                break
            }
        }
    }
    
//    private func fetchProfile(token: String) {
//        profileService.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                UIBlockingProgressHUD.dismiss()
//                self.switchToTabBarController()
//            case .failure:
//                UIBlockingProgressHUD.dismiss()
//                
//                break
//            }
//        }
//    }
}
