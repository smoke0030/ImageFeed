import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    private var ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListService = ImageListService.shared
    private var photos: [Photo] = []
    var imageListServiceObserver: NSObjectProtocol?
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimate()
            }
        imageListService.fetchPhotosNextPage()
        tableView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: ImageListService.DidChangeNotification, object: nil)
    }

    func configureCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let imageURL = photos[indexPath.row].thumbImageURL!
            let url = URL(string: imageURL)
        cell.imageCell.kf.indicatorType = .activity
        let placeholder = UIImage(named: "Stub")
        cell.imageCell.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
        
        guard let labelDate = photos[indexPath.row].createdAt else { return }
        let date = DateFormatter().fetchDate(dateString: labelDate)
        cell.dateLabel.text = date
        
        let isLiked = imageListService.photos[indexPath.row].isLiked == false
        let like = isLiked ? UIImage(named: "no_active") : UIImage(named: "Active")
        cell.likeButton.setImage(like, for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController {
                let indexPath = sender as! IndexPath
                let photo = photos[indexPath.row]
                guard let imageURL = URL(string: photo.largeImageURL!) else { return }
                viewController.imageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimate() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPaths: [IndexPath] = []
                for i in oldCount..<newCount {
                    indexPaths.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPaths, with: .bottom)
            } completion: { _ in }
        }
        
    }
    
    
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = photos[indexPath.row]
        let size = CGSize(width: cell.size.width, height: cell.size.height)
        let aspectRatio = size.width / size.height
        return tableView.frame.width / aspectRatio
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == imageListService.photos.count else { return }
        imageListService.fetchPhotosNextPage()
    }
}


extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configureCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
    
}
extension DateFormatter {
    func fetchDate(dateString: String) -> String {
        var formattedDateString: String!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd MMMM yyyy 'г.'"
            newDateFormatter.locale =  Locale(identifier: "ru_RU")
            formattedDateString = newDateFormatter.string(from: date)
        }
            return formattedDateString
    }
}
extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoID: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    
}
