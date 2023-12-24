import UIKit

struct Upgrade {
    var name: String
    var cost: Int
    var type: UpgradeType
}

enum UpgradeType {
    case autoClickerUnlock
    case autoClickerSpeed
    case moreTreats
}

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel2: UILabel!
    
    weak var delegate: ClickDelegate?

    var upgradesData = [
        Upgrade(name: "AutoClicker Unlock", cost: 100, type: .autoClickerUnlock),
        Upgrade(name: "2x AutoClicker", cost: 100, type: .autoClickerSpeed),
        Upgrade(name: "More Treats", cost: 100, type: .moreTreats),
    ]
    
   
    var treats = Int()
    
    var checkUpgradeValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "TreatTableCell", bundle: Bundle.main), forCellReuseIdentifier: "TreatTableCell")
       
        checkUpgradeValue = UserDefaults.standard.value(forKeyPath: "clickOption") as? String ?? ""
        
        tableView.reloadData()
        
        setupTreatCount()

    }
    
    func setupTreatCount() {
        let treatCountStr = UserDefaults.standard.value(forKeyPath: "clickCount") as? String ?? ""
        countLabel2.text = "Your Treats: \(treatCountStr)"
        treats = Int(treatCountStr) ?? 0
        print(treats)
    }

    
    private func updateLabel(count: Int) {
        countLabel2.text = "Your Treats: \(count)"
        treats = count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upgradesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TreatTableCell") as? TreatTableCell else {
            return UITableViewCell()
        }
        let upgrade = upgradesData[indexPath.row]
        cell.titleLbl.text = upgrade.name
        cell.costLbl.text = "Cost: \(upgrade.cost) treats"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let upgrade = upgradesData[indexPath.row]
        print(treats)
            
            switch indexPath.row {
            case 0:
                let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase1") as? String
                let purchaseOptionSelcted2 = UserDefaults.standard.value(forKeyPath: "Purchase2") as? String
                if  purchaseOptionSelcted == "yes" || purchaseOptionSelcted2 == "yes" {
                    showAlert(message: "Already Purchased")
                }
                else
                {
                    
                    if treats >= upgrade.cost {
                        // Deduct treats and apply upgrade
                        UserDefaults.standard.set("yes", forKey: "Purchase1")
                        treats -= upgrade.cost
                        UserDefaults.standard.set("\(treats)", forKey: "clickCount")
                        applyUpgrade(upgrade: upgrade)
                        setupTreatCount()
                        
                       showAlert(message: "Purchased Successfully")

                    } else {
                        showAlert(message: "Need 100 treats to buy AutoClick Unlock")
                    }
                }
            case 1:
                if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase2") as? String, purchaseOptionSelcted == "yes" {
                    showAlert(message: "Already Purchased")
                }
                else
                {
                    if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase1") as? String, purchaseOptionSelcted == "" {
                        showAlert(message: "You have to buy AutoClick Unlock first")
                    }
                    else
                    {
                        if treats >= upgrade.cost {
                            UserDefaults.standard.set("yes", forKey: "Purchase2")
                            UserDefaults.standard.set("no", forKey: "Purchase1")
                            // Deduct treats and apply upgrade
                            treats -= upgrade.cost
                            UserDefaults.standard.set("\(treats)", forKey: "clickCount")
                            applyUpgrade(upgrade: upgrade)
                            setupTreatCount()
                            showAlert(message: "Purchased Successfully")
                        } else {
                            showAlert(message: "Need 100 treats to buy 2x AutoClicker")
                        }
                    }
                }
            case 2:
                if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase3") as? String, purchaseOptionSelcted == "yes" {
                    showAlert(message: "Already purchased")
                }
                else
                {
                    
                    if treats >= upgrade.cost {
                        UserDefaults.standard.set("yes", forKey: "Purchase3")
                        treats -= upgrade.cost
                        UserDefaults.standard.set("\(treats)", forKey: "clickCount")
                        applyUpgrade(upgrade: upgrade)
                        setupTreatCount()
                       
                       showAlert(message: "Purchased Successfully")
                    } else {
                        showAlert(message: "Need 100 treats too buy More Treats")
                    }
                }
            default:
                break
            }
        self.delegate?.didUpdateCount(count: treats)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
    }
    
    func applyUpgrade(upgrade: Upgrade) {
        switch upgrade.type {
        case .autoClickerUnlock:
            startAutoClicker()
        case .autoClickerSpeed:
            increaseAutoClickerSpeed()
        case .moreTreats:
            increaseTreatsPerClick()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func startAutoClicker() {
        UserDefaults.standard.set("1", forKey: "clickOption")
    }
    
    func increaseAutoClickerSpeed() {
        UserDefaults.standard.set("2", forKey: "clickOption")
    }
    
    func increaseTreatsPerClick() {
        UserDefaults.standard.set("3", forKey: "clickOption")
    }
}
