//
//  ViewController.swift
//  MatchEmScene
//
//  Created by AJ Hughes on 10/31/20.
//  Copyright © 2020 AJ Hughes. All rights reserved.
//

import UIKit

class GameSceneViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBOutlet weak var gameInfoLabel: UILabel!
    
   private var isFirstClick: Bool = true
    private var firstClickButton : UIButton!
   
    private var gameInfo : String {
        // pairsCreated modify so that it only says theres a pair if they're the same
        // rectanglesMatched modify so that only says there's a pair if they are the same
        let labelText = "Time: \(secondCount) - Pairs: \(pairsCreated) - Matches: \(rectanglesMatched)"
        return labelText
    }
    
    
    
    private var pairsCreated: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
    private var rectanglesMatched: Int = 0 {
        didSet { gameInfoLabel?.text = gameInfo } }
    private var secondCount: Int = Int(gameDuration) {
        didSet { gameInfoLabel?.text = gameInfo } }
    
    // How long for the rectangle to fade away
    private var fadeDuration: TimeInterval = 0.8
    
    //================================================
    func removeRectangle(rectangle: UIButton) {
        // Rectangle fade animation
        let pa = UIViewPropertyAnimator(duration: fadeDuration,
                                           curve: .linear,
                                      animations: nil)
        pa.addAnimations {
            rectangle.alpha = 0.0
        }
        pa.startAnimation()
    }
    
    // Random transparency on or off
    private var randomAlpha = false

   // MARK: - ==== View Controller Methods ====
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // A game is in progress
    private var gameInProgress = false
    
    //================================================
    @objc private func handleTouch(sender: UIButton) {
        if (gameInProgress == false) {
            return
        }
        if (isFirstClick) {
            // Add emoji text to the rectangle
            sender.setTitle("💥", for: .normal)
            firstClickButton = sender
            isFirstClick = false
        } else {
            isFirstClick = true
            if (sender.backgroundColor == firstClickButton.backgroundColor &&
                sender.frame.size.width == firstClickButton.frame.size.width &&
                sender.frame.size.height == firstClickButton.frame.size.height) {
                // Add emoji text to the rectangle
                sender.setTitle("💥", for: .normal)
                rectanglesMatched += 1
                removeRectangle(rectangle: sender)
                removeRectangle(rectangle: firstClickButton)
            } else {
                firstClickButton.setTitle("", for: .normal)
                print("sender and first click are not same color")
            }
        }
        // Remove the rectangle
    }
    
    //================================================
    override func viewWillAppear(_ animated: Bool) {
        // Don't forget the call to super in these methods
        super.viewWillAppear(animated)
                        
        startGameRunning()
    }

}

// MARK: - ==== Config Properties ====
//================================================
// Min and max width and height for the rectangles
private let rectSizeMin:CGFloat =  50.0
private let rectSizeMax:CGFloat = 150.0

// MARK: - ==== Internal Properties ====

// Counters
private var pairsCreated = 0
private var rectanglesMatched = 0

// Keep track of all rectangles created
private var rectangles = [UIButton]()

// Rectangle creation interval
private var newRectInterval: TimeInterval = 1.2

// Rectangle creation, so the timer can be stopped
private var newRectTimer: Timer?

// Game duration
// 12 seconds required game time plus 1 since Welcome screen uses 1 second
private var gameDuration: TimeInterval = 12.0 + 1

// Time between updates of remaining time label
private var remainingDuration: TimeInterval = 1

// Game timer
// private var gameTimer: Timer?

// Remaining time timer
private var remainingTimer: Timer?

// Init the time remaining
private var gameTimeRemaining = gameDuration


// MARK: - ==== Timer Functions ====
extension GameSceneViewController {
    
    //================================================
    private func startGameRunning() {
        //================================================
        func removeSavedRectangles() {
            // Remove all rectangles from superview
            for rectangle in rectangles {
                rectangle.removeFromSuperview()
            }
            
            // Clear the rectangles array
            rectangles.removeAll()
        }
        gameInProgress = true
        // Timer to produce the rectangles
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                     repeats: true)
                                     { _ in self.createRectanglePair() }
        // Timer to end the game
        //gameTimer = Timer.scheduledTimer(withTimeInterval: gameDuration,
                       //repeats: false)
        //{ _ in self.stopGameRunning() }
        
        remainingTimer = Timer.scheduledTimer(withTimeInterval: remainingDuration,
                       repeats: true)
        { _ in self.updateRemainingTimeLabel() }
    }
 //================================================
//  private func stopGameRunning() {

//  }
    //================================================
     private func updateRemainingTimeLabel() {
        
        secondCount -= 1
        if (secondCount == 0) {
             gameInProgress = false
             // Stop the timer
             if let timer = newRectTimer { timer.invalidate() }
             // Stop the timer
             if let timer = remainingTimer { timer.invalidate() }

           // Remove the reference to the timer object
           //self.newRectTimer = nil
        }
    }

}




// MARK: - ==== Rectangle Methods ====
extension GameSceneViewController {
    private func createRectanglePair() {
        var firstRectangle = createRectangle()
        var secondRectangle = createRectangle()
        secondRectangle.backgroundColor = firstRectangle.backgroundColor
        secondRectangle.frame.size.height = firstRectangle.frame.size.height
        secondRectangle.frame.size.width = firstRectangle.frame.size.width
        pairsCreated+=1
    }
    
    //================================================
    private func createRectangle() -> UIButton {
        // Get random values for size and location
        let randSize     = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame  = CGRect(origin: randLocation, size: randSize)
        // Create a rectangle
        //_ = CGRect(x: 50, y: 150, width: 80, height: 40)
        let rectangle = UIButton(frame: randomFrame)
            
        // Do some button/rectangle setup
        rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
        rectangle.setTitle("", for: .normal)
        rectangle.setTitleColor(.black, for: .normal)
        rectangle.titleLabel?.font = .systemFont(ofSize: 50)
        rectangle.showsTouchWhenHighlighted = true
            
        // Make the rectangle visible
        self.view.addSubview(rectangle)
        rectangle.addTarget(self,
        action: #selector(self.handleTouch(sender:)),
        for: .touchUpInside)
        // Save the rectangle till the game is over
        rectangles.append(rectangle)
        // Move label to the front
        view.bringSubviewToFront(gameInfoLabel!)
        return rectangle
    }
    
}
