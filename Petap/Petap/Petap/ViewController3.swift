import UIKit

let dogApiKey = "live_qT37ErsK46sxZ4fOxWFn6SZQrq6c6piUYoSgAk9F6gW15qEpn94tInF4vhI6yafj"
let catApiKey = "live_Jo0OyN2yukNHkwMpEXImuDQQLSUQMjtM6PEe7Ij9nrX3nULzPGXqv5vhofSrMURY"

enum RollType {
    case Dog
    case Cat
    case None
}

class ViewController3: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var dogButton: UIButton!
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var selectedRollType : RollType = .None
    var selectedBreedId : String = ""
    
    var breeds: [[String:String]] {
        switch selectedRollType {
        case .Dog:
            return dogBreeds
        case .Cat:
            return catBreeds
        case .None:
            return []
        }
    }
    
    var images: [URL] = []
    var dogBreeds: [[String:String]] = []
    var catBreeds: [[String:String]] = []
    
    var imageStr = [String]()
    var treatCount = Int()
    @IBOutlet weak var pickerView: UIPickerView!

    @IBOutlet weak var buttonFetch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        buttonFetch.isHidden = true
        
        dogButton.addTarget(self, action: #selector(dogButtonTapped), for: .touchUpInside)
        catButton.addTarget(self, action: #selector(catButtonTapped), for: .touchUpInside)
        let getImageUrl = UserDefaults.standard.array(forKey: "RollImages") as? [String] ?? []
        if getImageUrl.count > 0 {
            if images.count > 0 {
                images.removeAll()
            }
            if imageStr.count > 0 {
                imageStr.removeAll()
            }
            for data in getImageUrl {
                let imageUrl = URL(string: data)!
                images.append(imageUrl)
                imageStr.append(data)
                print(images)
            }
        }
        setupTreatCount()
        
        dogButton.isEnabled = false
        catButton.isEnabled = false
        
        fetchBreeds(rollType: .Dog)
        fetchBreeds(rollType: .Cat)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]["name"]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = breeds[row]
        if let id = selectedItem["id"] {
            selectedBreedId = id
            buttonFetch.isHidden = false
        }
    }
    
    @IBAction func fecthImageAction(_ sender: Any) {
        pickerView.isHidden = true
        buttonFetch.isHidden = true
        fetchRandomImage()
    }
    
    func setupTreatCount() {
        let treatCountStr = UserDefaults.standard.value(forKeyPath: "clickCount") as? String ?? ""
        countLabel.text = "Your Treats: \(treatCountStr)"
        treatCount = Int(treatCountStr) ?? 0
    }
    
    func didClickButton(count: Int) {
        updateLabel(count: count)
    }

    private func updateLabel(count: Int) {
        countLabel.text = "Your Treats: \(count)"
    }

    @objc func dogButtonTapped() {
        if treatCount >= 100 {
            self.selectedRollType = .Dog
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
        }else {
            showAlert(message: "Need 100 treats")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func catButtonTapped() {
        if treatCount >= 100 {
            self.selectedRollType = .Cat
            self.pickerView.reloadAllComponents()
            self.pickerView.isHidden = false
        }else {
            showAlert(message: "Need 100 treats")
        }
    }

    func fetchBreeds(rollType: RollType) {
        var apiUrl: String

        if rollType == .Dog {
            apiUrl = "https://api.thedogapi.com/v1/breeds?limit=20"
        } else if rollType == .Cat {
            apiUrl = "https://api.thecatapi.com/v1/breeds?limit=20"
        } else {
            return
        }

        guard let url = URL(string: apiUrl) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data,
               let breeds = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                if rollType == .Dog {
                    self.dogBreeds.removeAll()
                    DispatchQueue.main.async {
                        self.dogButton.isEnabled = true
                    }
                } else if rollType == .Cat {
                    self.catBreeds.removeAll()
                    DispatchQueue.main.async {
                        self.catButton.isEnabled = true
                    }
                }
                breeds.forEach({ _raw in
                    if rollType == .Dog {
                        if let id = _raw["id"] as? Int,let name = _raw["name"] as? String {
                            self.dogBreeds.append(["id":"\(id)","name":name])
                        }
                    } else if rollType == .Cat {
                        if let id = _raw["id"] as? String,let name = _raw["name"] as? String {
                            self.catBreeds.append(["id":id,"name":name])
                        }
                    }
                })
                
            } else {
                DispatchQueue.main.async {
                    self.showNotification(message: "Failed to grab breeds")
                }
            }
        }
        task.resume()
    }
    
    func fetchRandomImage() {
        var apiUrl: String

        if selectedRollType == .Dog {
            apiUrl = "https://api.thedogapi.com/v1/images/search?limit=1&breed_ids=\(selectedBreedId)&api_key=\(dogApiKey)"
        } else if selectedRollType == .Cat {
            apiUrl = "https://api.thecatapi.com/v1/images/search?limit=1&breed_ids=\(selectedBreedId)&api_key=\(dogApiKey)"
        } else {
            return
        }

        guard let url = URL(string: apiUrl) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
               let imageUrlString = json.first?["url"] as? String,
               let imageUrl = URL(string: imageUrlString) {

                self.images.append(imageUrl)
                self.imageStr.append(imageUrlString)
                print(self.imageStr)
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(self.imageStr, forKey: "RollImages")
                    self.goTONextScreenWithArr()
                    self.treatCount -= 100
                    UserDefaults.standard.set("\(self.treatCount)", forKey: "clickCount")
                    
                    self.setupTreatCount()
                    self.showNotification(message: "Image grabbed successfully")
                }
            } else {
                DispatchQueue.main.async {
                    self.showNotification(message: "Failed to grab image")
                }
            }
        }

        task.resume()
    }
    
    func goTONextScreenWithArr(){
        self.performSegue(withIdentifier: "RollToShowRollImg", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vw = segue.destination as? ShowImageViewController {
            vw.RollImages = self.images
        }
    }
    
    func showNotification(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController3: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.load(url: images[indexPath.item])
        cell.contentView.addSubview(imageView)

        return cell
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
