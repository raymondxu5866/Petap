import UIKit

protocol ClickDelegate: AnyObject {
    func didUpdateCount(count: Int)
}

class ViewController: UIViewController, UITextFieldDelegate, ClickDelegate {
    
    
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var clickCountLabel1: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
        
    var clickCount = 0
    var clickCheckCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameLabel.delegate = self
        UserDefaults.standard.set("0", forKey: "clickCount")
        UserDefaults.standard.set("", forKey: "clickOption")
        UserDefaults.standard.set("", forKey: "Purchase1")
        UserDefaults.standard.set("", forKey: "Purchase2")
        UserDefaults.standard.set("", forKey: "Purchase3")
        UserDefaults.standard.set([], forKey: "RollImages")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickButtonTapped))
        clickButton.addGestureRecognizer(tapGesture)
        clickButton.isUserInteractionEnabled = true

        clickButton.layer.cornerRadius = 16
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let treatCountStr = UserDefaults.standard.value(forKeyPath: "clickCount") as? String ?? ""
        clickCountLabel1.text = "Your Treats: \(treatCountStr)"
        clickCount = Int(treatCountStr) ?? 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return nameLabel.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func upgradeAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController2") as? ViewController2 {
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func didUpdateCount(count: Int) {
        clickCountLabel1.text = "Your Treats: \(count)"
        clickCount = Int(count)
    }
    
    @IBAction func clickButtonTapped(_ sender: UIButton)
    {
        
        let checkUpgradeValue = UserDefaults.standard.value(forKeyPath: "clickOption") as? String ?? ""
        if checkUpgradeValue == "1" {
            clickCheckCount += 1
           
            if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase3") as? String, purchaseOptionSelcted == "yes" {
                clickCount += 2
                
                clickCountLabel1.text = "Your Treats: \(clickCount)"
                if clickCheckCount >= 10 {
                    clickCount +=  1
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    clickCheckCount = 0
                }
            }else {
                clickCount += 1
                clickCountLabel1.text = "Your Treats: \(clickCount)"
                if clickCheckCount >= 10 {
                    clickCount += 1
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    clickCheckCount = 0
                }
            }
            
        }else if checkUpgradeValue == "2"
        {
            clickCheckCount += 1
           
            if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase3") as? String, purchaseOptionSelcted == "yes" {
                clickCount +=  2
                clickCountLabel1.text = "Your Treats: \(clickCount)"
                if clickCheckCount >= 5 {
                    clickCount +=  1
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    clickCheckCount = 0
                }
            }else {
                clickCount += 1
                clickCountLabel1.text = "Your Treats: \(clickCount)"
                if clickCheckCount >= 5 {
                    clickCount +=  1
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    clickCheckCount = 0
                }
            }
            
           
        }else if checkUpgradeValue == "3"
        {
            let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase1") as? String
            let purchaseOptionSelcted2 = UserDefaults.standard.value(forKeyPath: "Purchase2") as? String
            let purchaseOptionSelcted3 = UserDefaults.standard.value(forKeyPath: "Purchase3") as? String
            if  purchaseOptionSelcted3 == "yes" && purchaseOptionSelcted == "no" && purchaseOptionSelcted2 == "yes"
            {
                clickCheckCount += 1
                clickCount += 2
                clickCountLabel1.text = "Your Treats: \(clickCount)"
                if clickCheckCount >= 5 {
                    clickCount +=  1
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    clickCheckCount = 0
                }
            }
            else
            {
                if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase1") as? String, purchaseOptionSelcted == "yes" {
                    clickCheckCount += 1
                    clickCount += 2
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                    if clickCheckCount >= 10 {
                        clickCount +=  1
                        clickCountLabel1.text = "Your Treats: \(clickCount)"
                        clickCheckCount = 0
                    }
                }else if let purchaseOptionSelcted = UserDefaults.standard.value(forKeyPath: "Purchase2") as? String, purchaseOptionSelcted == "yes" {
                    if clickCheckCount >= 5 {
                        clickCount +=  2
                        clickCountLabel1.text = "Your Treats: \(clickCount)"
                        clickCheckCount = 0
                    }
                }else {
                    clickCheckCount += 1
                    clickCount += 2
                    clickCountLabel1.text = "Your Treats: \(clickCount)"
                }
            }

        }else {
            clickCount += 1
            clickCountLabel1.text = "Your Treats: \(clickCount)"
        }
        
        UserDefaults.standard.set("\(clickCount)", forKey: "clickCount")
        
        UIView.animate(withDuration: 0.1, animations: {
            self.clickButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.clickButton.transform = .identity
            }
        }
    }
}

