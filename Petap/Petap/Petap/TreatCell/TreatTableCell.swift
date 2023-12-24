import UIKit

class TreatTableCell: UITableViewCell {

    @IBOutlet var costLbl: UILabel!
    @IBOutlet var subVw: UIView!
    @IBOutlet var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        subVw.layer.cornerRadius = 15.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
