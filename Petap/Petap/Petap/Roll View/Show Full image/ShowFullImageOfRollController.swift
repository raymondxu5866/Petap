import UIKit

class ShowFullImageOfRollController: UIViewController {
    @IBOutlet var fullImageShow: UIImageView!
    @IBOutlet var subVw: UIView!
   var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        fullImageShow.layer.cornerRadius = 10.0
        subVw.layer.cornerRadius = 10.0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        fullImageShow.load(url: URL(string: urlString)!)
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
