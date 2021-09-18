//
//  ViewController.swift
//  ImageTest
//
//  Created by Mohammad Kiani on 2019-10-30.
//  Copyright © 2019 mohammadkiani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Custom UI elements
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet var choices: [UIButton]!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var lifeLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    /// var points that is the accumulated point of the users
    var points = 0
    /// var lives that refers to the number of times the player can play before being gane over
    var lives = 5
    var imageName = ""
    var stuff: [(name: String, label: String)]?
    
    var seconds = 5
//    var timer = Timer()
    var timer: Timer?
    var isTimerRunning = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stuff = [("Dog","🐶"), ("Cat", "🐱"), ("Mice", "🐭"), ("Fox", "🦊"), ("Rooster", "🐔"), ("Panda", "🐼"), ("Pumkin", "🎃"), ("Ghost", "👻"), ("Dice", "🎲"), ("Game", "🎳")]
        lifeLabel.text = "Lives: 10"
        pointLabel.text = "Points: 0"
    }
    
    func drawRandomStuff() {
        runTimer()
        seconds = 5
        updateLabels(points: points, lives: lives, seconds: seconds)
        let count: UInt32 = UInt32(stuff?.count ?? 0)
        let randomImageIndex = randomNumber(number: count)
        imageLabel.text = stuff![randomImageIndex].label
        imageName = stuff![randomImageIndex].name
        var btnNames = Set<String>()
        let randomIndex = randomNumber(number: 4)
        choices[randomIndex].setTitle(stuff![randomImageIndex].name, for: .normal)
        while btnNames.count != 4 {
            let index = randomNumber(number: count)
            if index != randomImageIndex {
                btnNames.insert(stuff![index].name)
            }
        }
        for index in 0..<4 {
            if index == randomIndex { continue }
//            var randomStuffIndex = randomNumber(number: count)
//            while randomStuffIndex == randomImageIndex {
//                randomStuffIndex = randomNumber(number: count)
//            }
//            choices[index].setTitle(stuff![randomStuffIndex].name, for: .normal)
            choices[index].setTitle(btnNames[btnNames.index(btnNames.startIndex, offsetBy: index)], for: .normal)
        }
    }

    @IBAction func startGame(_ sender: UIButton) {
        drawRandomStuff()
        startBtn.isHidden = true
        for choice in choices {
            choice.isEnabled = true
        }
    }
    
    func randomNumber(number: UInt32) -> Int {
        return Int(arc4random_uniform(number))
    }
    @IBAction func selectChoice(_ sender: UIButton) {
        guard lives > 0 else {return}
        checkPoint(sender)
        updateLabels(points: points, lives: lives, seconds: seconds)
        if lives <= 0 {stopTimer(); playAgain()}
        drawRandomStuff()
    }
    /**
     - parameters sender: UIButton that is sent to this function
    */
    func checkPoint(_ sender: UIButton) {
        if sender.titleLabel?.text == imageName {
            points += 1
        }
        else {
            lives -= 1
        }
    }
    
    func playAgain() {
//        isTimerRunning = false
        let alertController = UIAlertController(title: "Game Over", message: "Do you wanna play again?", preferredStyle: .alert)
        let yestAction = UIAlertAction(title: "yes", style: .default) { (action) in
            self.drawRandomStuff()
            self.lives = 5
            self.lifeLabel.text = "Lives: \(self.lives)"
        }
        let noAction = UIAlertAction(title: "no", style: .cancel, handler: nil)
        alertController.addAction(yestAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func runTimer() {
        guard timer == nil else {return}
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
//        isTimerRunning = true
    }
    
    @objc func updateTimer() {
        guard lives > 0 else {return}
        if seconds < 1 {
            stopTimer()
            lives -= 1
            updateLabels(points: points, lives: lives, seconds: seconds)
            if lives == 0 {
                playAgain()
            }
            else {
                drawRandomStuff()
            }
            
        }
        else {
            seconds -= 1     //This will decrement(count down)the seconds.
            timerLabel.text = "\(seconds)" //This will update the label.
        }
    }
    
    func updateLabels(points: Int, lives: Int, seconds: Int) {
        pointLabel.text = "Point: \(points)"
        lifeLabel.text = "Lives: \(lives)"
        timerLabel.text = "\(seconds)"
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    func stopGame() {
        stopTimer()
        
    }
}

