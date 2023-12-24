import UIKit

class ShowImageViewController: UIViewController {

    @IBOutlet var imageCollectionCell: UICollectionView!
    var RollImages: [URL] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        imageCollectionCell.register(UINib.init(nibName: "ShowRollSelectedImgCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ShowRollSelectedImgCell")
        imageCollectionCell.delegate = self
        imageCollectionCell.dataSource = self
        imageCollectionCell.reloadData()
    }
}

extension ShowImageViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return RollImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowRollSelectedImgCell", for: indexPath) as? ShowRollSelectedImgCell else {
            return UICollectionViewCell()
        }
        cell.showRollImg.load(url: RollImages[indexPath.row])
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(RollImages[indexPath.row])")
        let controller  = ShowFullImageOfRollController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.urlString = "\(RollImages[indexPath.row])"
        self.present(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let referenceHeight: CGFloat = 100
        let referenceWidth = self.imageCollectionCell.frame.size.width/3
           
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0;
        }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layoutSubviews()
    }
}
