import WebKit

protocol ProfileViewPresenterProtocol {
    func showAlert() -> UIAlertController
    func viewDidLoad()
    func updateProfileDetails(profile: Profile?)
    func logout()
    func clean()
    func fetchProfileURL() -> URL
    
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    func viewDidLoad() {
        updateProfileDetails(profile: ProfileService.shared.profile)
        observeAvatar()
    }
    
    func fetchProfileURL() -> URL {
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL)
        else { return URL(string: "")! }
        return url
    }
    
    func observeAvatar() {
        let url = fetchProfileURL()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: self,
                         queue: .main
            )  { [weak self] _ in
                guard let self = self  else { return }
                view?.updateAvatar(url: url)
            }
        view?.updateAvatar(url: url)
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        view?.nameLabel.text = profile.name
        view?.loginLabel.text = profile.username
        view?.descriptionLabel.text = profile.bio
    }
    
    func showAlert() -> UIAlertController {
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
        return alert
    }
    
    func logout()  {
        OAuth2TokenStorage.shared.removeKey()
        clean()
        let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TabBarViewController")
        tabBarController.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("error") }
        window.rootViewController = SplashViewController()
    }
    
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}


