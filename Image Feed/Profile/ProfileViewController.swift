import UIKit
import Kingfisher
import SwiftKeychainWrapper
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get set }
    var imageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
    func updateAvatar(url: URL)
}

class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    }()
    
    private let profileService =  ProfileService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        presenter.viewDidLoad()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalToConstant: 70),
                                    imageView.heightAnchor.constraint(equalToConstant: 70),
                                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                    imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                                     nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
                                     loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
                                     descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                                     descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
                                     exitButton.widthAnchor.constraint(equalToConstant: 44),
                                     exitButton.heightAnchor.constraint(equalToConstant: 44),
                                     exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                                     exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
                                     ])
    }
    
    func updateAvatar(url: URL) {
        imageView.kf.indicatorType = .activity
        let placeholderImage = UIImage(named: "placeholder")
        imageView.kf.setImage(with: url, placeholder: placeholderImage, options: [])
    }
    
    func setupViews() {
        view.backgroundColor = UIColor(named: "ypBlack")
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile_image"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        return label
    }()
    
    var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    var descriptionLabel =  {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "Hello, world!"
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    var exitButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(systemName: "ipad.and.arrow.forward")!,
                                           target: self,
                                           action: #selector(exitButtonAction)
        )
        button.tintColor = UIColor(named: "YP Red")
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func showAlert() {
        let alert = presenter.showAlert()
        present(alert, animated: true)
    }
    
    @objc func exitButtonAction() {
        showAlert()
    }
}
