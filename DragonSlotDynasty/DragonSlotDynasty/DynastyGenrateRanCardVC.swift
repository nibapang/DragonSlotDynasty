//
//  DynastyGenrateRanCardVC.swift
//  DragonSlotDynasty
//
//  Created by SunTory on 2025/2/25.
//

import UIKit

class DynastyGenrateRanCardVC: UIViewController {

    @IBOutlet weak var randomCard: UIImageView!
    
    var cardImgName = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12"]
    var timer = Timer()
    var timerCounter = 0.00
    var animationDuration: Double = 0.5  // Default animation duration
    var selectedCard: String = ""  // Store the final selected card

    override func viewDidLoad() {
        super.viewDidLoad()
        adjustAnimationBasedOnScreenSize()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //startTimer()
    }
    
    // MARK: - Adjust Animation Speed Based on Screen Size
    func adjustAnimationBasedOnScreenSize() {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth > 800 {  // For iPads or large devices
            animationDuration = 0.7
        } else if screenWidth < 400 {  // Small devices
            animationDuration = 0.3
        } else {
            animationDuration = 0.5
        }
    }
    
    // MARK: - Start Timer for Random Card Animation
    func startTimer() {
        timerCounter = 0.00  // Reset timer
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateCards), userInfo: nil, repeats: true)
    }
    
    @IBAction func back(_ sender: Any) {
        timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }

    
    @objc func updateCards() {
        timerCounter += 0.05
        
        if timerCounter > 2.0 {
            timer.invalidate()
            selectedCard = cardImgName.randomElement()!  // Store the final selected card
            animateCardFlip(newCard: selectedCard)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                self.showAlert(title: "🎴 Card Challenge!",
                               message: "In the next screen, you'll have **3 seconds** to find and select **\(self.selectedCard)** from 15 cards. Stay sharp! 🚀",
                               selectedCard: self.selectedCard)
            }

        } else {
            let tempCard = cardImgName.randomElement()!
            animateCardFlip(newCard: tempCard)
        }
    }
    
    // MARK: - Animate Card Flip Effect
    func animateCardFlip(newCard: String) {
        UIView.transition(with: randomCard, duration: animationDuration, options: .transitionFlipFromLeft, animations: {
            self.randomCard.image = UIImage(named: newCard)
        }, completion: nil)
    }
    
    // MARK: - Show Alert and Pass Selected Card
    func showAlert(title: String, message: String, selectedCard: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionButton = UIAlertAction(title: "Go to Select", style: .default) { _ in
            if let next = self.storyboard?.instantiateViewController(withIdentifier: "DynastyCardGameVC") as? DynastyCardGameVC {
                next.getRanCard = selectedCard  // Pass the selected card
                self.navigationController?.pushViewController(next, animated: true)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Reset", style: .cancel) { _ in
            self.startTimer()  // Restart the timer if user cancels
        }
        
        alert.addAction(actionButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
}
