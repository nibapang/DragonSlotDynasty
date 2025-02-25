//
//  DynastySlotDynastyVC.swift
//  DragonSlotDynasty
//
//  Created by SunTory on 2025/2/25.
//

import UIKit

class DynastySlotDynastyVC: UIViewController {

    @IBOutlet weak var reel1: UIPickerView!
    @IBOutlet weak var reel2: UIPickerView!
    @IBOutlet weak var reel3: UIPickerView!
    
    var slotElements = ["slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reel1.dataSource = self
        reel1.delegate = self
        reel2.dataSource = self
        reel2.delegate = self
        reel3.dataSource = self
        reel3.delegate = self
    }
    
    // MARK: - Spin Button Action
    @IBAction func SpinButton(_ sender: Any) {
        spinReels()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Slot Machine Spin Logic
    func spinReels() {
        let randomRow1 = Int.random(in: 0..<slotElements.count) // Generate a random row for reel 1
        let randomRow2 = Int.random(in: 0..<slotElements.count) // Generate a random row for reel 2
        let randomRow3 = Int.random(in: 0..<slotElements.count) // Generate a random row for reel 3
        
        print("Spinning to:", randomRow1, randomRow2, randomRow3)

        // Disable interaction during spin
        view.isUserInteractionEnabled = false

        // Spin Reel 1
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseOut], animations: {
            self.reel1.selectRow(self.slotElements.count * 5 + randomRow1, inComponent: 0, animated: true)
        }, completion: nil)

        // Spin Reel 2
        UIView.animate(withDuration: 1.3, delay: 0.3, options: [.curveEaseOut], animations: {
            self.reel2.selectRow(self.slotElements.count * 5 + randomRow2, inComponent: 0, animated: true)
        }, completion: nil)

        // Spin Reel 3
        UIView.animate(withDuration: 1.6, delay: 0.6, options: [.curveEaseOut], animations: {
            self.reel3.selectRow(self.slotElements.count * 5 + randomRow3, inComponent: 0, animated: true)
        }, completion: { _ in
            self.view.isUserInteractionEnabled = true
            self.checkWinningCombination(row1: randomRow1, row2: randomRow2, row3: randomRow3)
        })
    }
    
    // MARK: - Check If User Wins
    func checkWinningCombination(row1: Int, row2: Int, row3: Int) {
        if slotElements[row1] == slotElements[row2] && slotElements[row2] == slotElements[row3] {
            showAlert(title: "🎉 JACKPOT! 🎉", message: "Incredible! You hit the jackpot with \(slotElements[row1]).\nKeep spinning for more luck!", isJackpot: true)
        } else if slotElements[row1] == slotElements[row2] || slotElements[row2] == slotElements[row3] || slotElements[row1] == slotElements[row3] {
            showAlert(title: "Almost There! 🤏", message: "You got two matching symbols!\nKeep spinning, your big win is coming!", isJackpot: false)
        } else {
            showAlert(title: "❌ Try Again", message: "No matches this time.\nGive it another spin and test your luck!", isJackpot: false)
        }
    }
    
    // MARK: - Show Friendly Alerts with Custom Messages
    func showAlert(title: String, message: String, isJackpot: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "🎯 Spin Again!", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true) {
            if isJackpot {
                self.shakeScreen() // Shake screen only for a jackpot win
            }
        }
    }

    // MARK: - Shake Effect for Jackpot Win
    func shakeScreen() {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.timingFunction = CAMediaTimingFunction(name: .linear)
        shake.duration = 0.5
        shake.values = [-10, 10, -8, 8, -5, 5, 0]
        view.layer.add(shake, forKey: "shake")
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension DynastySlotDynastyVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slotElements.count * 10 // Large number to create a continuous spin effect
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let rowView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // Row size
        
        // Create an ImageView for the slot element
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 55))
        imageView.image = UIImage(named: slotElements[row % slotElements.count]) // Use modulo to loop through images
        imageView.contentMode = .scaleAspectFit
        
        // Add ImageView to row
        rowView.addSubview(imageView)
        
        return rowView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 75 // Height for rows
    }
}
