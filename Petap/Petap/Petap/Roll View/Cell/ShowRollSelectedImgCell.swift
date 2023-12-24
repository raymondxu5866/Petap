import UIKit

class ShowRollSelectedImgCell: UICollectionViewCell {

    @IBOutlet var showRollImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

        showRollImg.layer.cornerRadius = 10.0
    }
}
