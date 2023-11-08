import UIKit

final class ImageListCell: UITableViewCell {
    
    weak var delegate: ImageListCellDelegate?
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let like = isLiked ? UIImage(named: "Active") : UIImage(named: "no_active")
//        likeButton.imageView?.image = like
        likeButton.setImage(like, for: .normal)
    }
}

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell:ImageListCell)
}
