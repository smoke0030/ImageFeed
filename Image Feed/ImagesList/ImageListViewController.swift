import UIKit
import Kingfisher


protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListViewPresenterProtocol { get set }
    func updateTableViewAnimate()
//    var photos: [Photo] {get set}
}

final class ImageListViewController: UIViewController & ImageListViewControllerProtocol {
    private var ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListService = ImageListService.shared
    //    var photos: [Photo] = []
    var imageListServiceObserver: NSObjectProtocol?
    
    var presenter: ImageListViewPresenterProtocol = {
        return ImageListViewPresenter()
    }()
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
        tableView.delegate = self
        presenter.view = self
        tableView.dataSource = self
    }
    
    func configureCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let imageURL = presenter.photos[indexPath.row].thumbImageURL else { return }
        let url = URL(string: imageURL)
        cell.imageCell.kf.indicatorType = .activity
        let placeholder = UIImage(named: "Stub")
        cell.imageCell.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            cell.imageCell.kf.indicatorType = .none
        }
        
        let labelDate = presenter.photos[indexPath.row].createdAt
        cell.dateLabel.text = presenter.fetchDate(dateString: labelDate ?? Date())
        
        let isLiked = imageListService.photos[indexPath.row].isLiked == false
        let like = isLiked ? UIImage(named: "no_active") : UIImage(named: "Active")
        cell.likeButton.setImage(like, for: .normal)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController {
                let indexPath = sender as! IndexPath
                let photo = presenter.photos[indexPath.row]
                guard let url = photo.largeImageURL,
                      let imageURL = URL(string: url) else { return }
                viewController.imageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimate() {
        let oldCount = presenter.photos.count
        let newCount = imageListService.photos.count
        presenter.photos = imageListService.photos
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
    
    func checkCompletedList(_ indexPath: IndexPath) {
        if imageListService.photos.isEmpty || (indexPath.row + 1 == imageListService.photos.count) {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = presenter.photos[indexPath.row]
        let size = CGSize(width: cell.size.width, height: cell.size.height)
        let aspectRatio = size.width / size.height
        return tableView.frame.width / aspectRatio
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard indexPath.row + 1 == imageListService.photos.count else { return }
//        imageListService.fetchPhotosNextPage()
        checkCompletedList(indexPath)
    }
}


extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
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
extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = presenter.photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoID: photo.id, isLike: photo.isLiked) { result in
            switch result {
            case .success:
                self.presenter.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.presenter.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
