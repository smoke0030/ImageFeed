import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    private let imageView = UIImageView(image: UIImage(named: "profile_image"))
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let profileService =  ProfileService.shared
    private let profileImageService  = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageView()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addExitButton()
        updateProfileDetails(profile: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(forName: ProfileImageService.DidChangeNotification,
                         object: nil,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let exitButton = UIButton()
        exitButton.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        exitButton.tintColor = UIColor(named: "YP Red")
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
    }
    
}

extension ProfileViewController {
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else {return}
        nameLabel.text = profile.name
        loginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
//    private func fetchProfile(token: String) {
//        profileService.fetchProfile(token) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                
//                updateProfileDetails(profile: profileService.profile)
//            case .failure:
//               
//                
//                break
//            }
//        }
//    }
    
//    func fetchProfileImage(token: String) {
//        guard let username = profileService.profile?.username else { return }
//        profileImageService.fetchProfileImageURL(token: token, username: username) { result in
//            switch result {
//            case .success:
//                print("Hih")
//            case .failure(let error):
//                print(error.localizedDescription)
//                
//            }
//        }
//    }
    
}
