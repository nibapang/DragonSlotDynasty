//
//  DynastyCardGameVC.swift
//  DragonSlotDynasty
//
//  Created by SunTory on 2025/2/25.
//

import UIKit

class DynastyCardGameVC: UIViewController {
    
    @IBOutlet var cardCollection: [UIButton]!
    @IBOutlet weak var timerLbl: UILabel!
    
    var cardImgName = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12"]
    var getRanCard = ""  // The target card user must select
    var timer = Timer()
    var timeRemaining: Double = 3.000  // Start at 3 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Target Card: \(getRanCard)")
        
        // Shuffle and assign images to buttons
        let shuffledImages = cardImgName.shuffled()
        for (index, button) in cardCollection.enumerated() {
            if index < shuffledImages.count {
                let imageName = shuffledImages[index]
                button.setImage(UIImage(named: imageName), for: .normal)
                button.accessibilityIdentifier = imageName // Store image name for reference
            }
        }
        
        startTimer()
    }
    
    // MARK: - Start Countdown Timer
    func startTimer() {
        timerLbl.text = String(format: "%.3f", timeRemaining) // Initialize label
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeRemaining -= 0.01
        timerLbl.text = String(format: "%.3f", timeRemaining) // Update timer label
        
        if timeRemaining <= 0 {
            timer.invalidate()
            showAlert(title: "⏳ Time's Up!", message: "You ran out of time! The correct card was **\(getRanCard)**. Try again!", isWin: false)
        }
    }
    
    // MARK: - Handle Card Selection
    @IBAction func cardTapped(_ sender: UIButton) {
        timer.invalidate()  // Stop the timer
        
        // Get the stored image name from the button
        if let selectedCard = sender.accessibilityIdentifier {
            if selectedCard == getRanCard {
                showAlert(title: "🎉 You Won!", message: "Great job! You selected **\(getRanCard)** in time!", isWin: true)
            } else {
                showAlert(title: "❌ Wrong Card", message: "Oops! You selected **\(selectedCard)** instead of **\(getRanCard)**. Try again!", isWin: false)
            }
        } else {
            showAlert(title: "⚠️ Error", message: "Something went wrong. Try again.", isWin: false)
        }
    }
    
    // MARK: - Show Win/Lose Alert
    func showAlert(title: String, message: String, isWin: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: isWin ? "🎯 Play Again" : "🔄 Try Again", style: .default) { _ in
            self.restartGame()
        }
        alert.addAction(actionButton)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Restart the Game
    func restartGame() {
        timeRemaining = 3.000
        startTimer()
    }
    
    @IBAction func back(_ sender: Any) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }

    
}
