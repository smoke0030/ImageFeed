import UIKit
import Kingfisher
import SwiftKeychainWrapper
import WebKit

class ProfileViewController: UIViewController {
    
    private let exitButton = UIButton()
    private let imageView = UIImageView(image: UIImage(named: "profile_image"))
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileService =  ProfileService.shared
    private let profileImageService  = ProfileImageService.shared
    private let oAuthTokenStorage = OAuth2TokenStorage.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ypBlack")
        addImageView()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addExitButton()
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: self,
                         queue: .main
                         )  { [weak self] _ in
                guard let self = self  else { return }
                self.updateAvatar()
            }
        updateAvatar()
        
        
    }
    
    private func updateAvatar(){
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        imageView.kf.indicatorType = .activity
        let placeholderImage = UIImage(named: "placeholder")
        imageView.kf.setImage(with: url, placeholder: placeholderImage, options: [])
    }
    
    private func addImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func addNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive =  true
        
    }
    
    private func addLoginLabel() {
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.textColor = .gray
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addExitButton() {
        exitButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: #selector(exitButtonAction) , for: .touchUpInside)
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    private func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func logout()  {
        oAuthTokenStorage.removeKey()
        clean()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("error") }
        window.rootViewController = SplashViewController()
    }
    
    @objc func exitButtonAction() {
        showAlert()
    }
    
}

extension ProfileViewController {
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else {return}
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "До встречи!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Нет", 
                                      style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Да",
                                      style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            logout()
        }))
        
        self.present(alert, animated: true)
    }
}
