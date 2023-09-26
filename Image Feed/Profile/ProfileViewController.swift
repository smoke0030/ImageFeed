import UIKit

class ProfileViewController: UIViewController {
    
    let imageView = UIImageView(image: UIImage(named: "profile_image"))
    let nameLabel = UILabel()
    let loginLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImageView()
        addNameLabel()
        addLoginLabel()
        addDescriptionLabel()
        addExitButton()
      
    }
    
    func addImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
        
    }
    
    func addNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .white
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = UIFont.systemFont(ofSize: 23)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive =  true
    }
    
    func addLoginLabel() {
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.textColor = .gray
        loginLabel.text = "@ekaterina_nov"
        loginLabel.font = UIFont.systemFont(ofSize: 13)
        loginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func addDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    func addExitButton() {
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
