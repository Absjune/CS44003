//
//  GameSceneViewController.swift
//  MatchEmNav
//
//  Created by AJ Hughes on 12/10/20.
//  Copyright © 2020 AJ Hughes. All rights reserved.
//

import UIKit

class GameSceneViewController: UIViewController {

    //@IBAction func swipeAction(_ sender: Any) {
    //}
    
    override var prefersStatusBarHidden: Bool {
                return true
            }

     /*   init() {
            self.secondCount = Int(self.gameDuration)
            self.gameTimeRemaining = Double(self.gameDuration)
            super.init(nibName: nil, bundle: nil)
        }
     */
        
        required init?(coder aDecoder: NSCoder) {
            self.secondCount = Int(self.gameDuration)
          //  self.gameTimeRemaining = Double(self.gameDuration)
            super.init(coder: aDecoder)
        }
        
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
        

    @IBOutlet weak var gameInfoLabel: UILabel!
    
        // ------------------------

        // Game timer
        private var gameTimer: Timer?

        private var gameRunning    = false
        
        // Rectangle creation interval
        public var newRectInterval: TimeInterval = 1.2
        
        public var newRectIntervalMax: TimeInterval = 5.0
        public var newRectIntervalMin = 0.1

        // Game duration
        // 12 seconds required game time plus 1 since Welcome screen uses 1 second
        public var gameDuration: TimeInterval = 12.0 + 1
        
        public var gameDurationMin: TimeInterval = 20.0
        public var gameDurationMax: TimeInterval = 1.0
      
        
        
        // ------------------------

        
        private var isFirstClick: Bool = true
        private var firstClickButton : UIButton!
           
            private var gameInfo : String {
                // pairsCreated modify so that it only says theres a pair if they're the same
                // rectanglesMatched modify so that only says there's a pair if they are the same
                let labelText = "Time: \(secondCount) - Pairs: \(pairsCreated) - Matches: \(rectanglesMatched)"
                return labelText
            }
            
        
        var matchEmoji: String = "💥"
        var rectFill: Bool = true

            
        // Counters, property observers used
         private var rectanglesCreated = 0 {
             didSet { gameInfoLabel?.text = gameInfo } }
         private var rectanglesTouched = 0 {
             didSet { gameInfoLabel?.text = gameInfo } }

            
            private var pairsCreated: Int = 0 {
                didSet { gameInfoLabel?.text = gameInfo } }
            private var rectanglesMatched: Int = 0 {
                didSet { gameInfoLabel?.text = gameInfo } }
            public var secondCount: Int {
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
    

        
        func matchingRectangles(sender: UIButton)->Bool {
            if (rectFill) {
                return (sender.backgroundColor == firstClickButton.backgroundColor &&
                    sender.frame.size.width == firstClickButton.frame.size.width &&
                    sender.frame.size.height == firstClickButton.frame.size.height)
            } else {
                return (sender.layer.borderColor == firstClickButton.layer.borderColor &&
                    sender.frame.size.width == firstClickButton.frame.size.width &&
                    sender.frame.size.height == firstClickButton.frame.size.height)
            }
            
        }
        
            
            // A game is in progress
            private var gameInProgress = false
            
            //================================================
        @objc func handleTouch(sender: UIButton) {
                if (gameInProgress == false) {
                    return
                }
                if (isFirstClick) {
                    // Add emoji text to the rectangle
                    sender.setTitle(matchEmoji, for: .normal)
                    firstClickButton = sender
                    isFirstClick = false
                } else {
                    isFirstClick = true
                    if (matchingRectangles(sender: sender)) {
                        // Add emoji text to the rectangle
                        sender.setTitle(matchEmoji, for: .normal)
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
               
                if gameInProgress {
                    resumeGameRunning()
                }
                
     //           startGameRunning()
               }
        
        
        //================================================
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            //
            if gameInProgress {
                pauseGameRunning()
            }
        }
        
        //================================================
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        // Two finger touch required
         if sender.numberOfTouchesRequired != 2 {
              return
          }
              
          // If no game is in progress start a new game
          if !gameInProgress {
              startNewGame()
              return
          }
              
          // We have a game in progress, pause or resume?
          if gameRunning {
              pauseGameRunning()
          } else {
              resumeGameRunning()
          }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  
        }
        

        func startNewGame() {
            // Clear the rectangles
            removeSavedRectangles()

            // Reset the time remaing to the full game time
            self.secondCount = Int(self.gameDuration)
            
            // Reset the game stat vars
            rectanglesCreated = 0
            rectanglesTouched = 0
            
            // Adjust the label background
//            gameInfoLabel.backgroundColor = .clear

            // Game operation
            gameInProgress = true
            
            //
            resumeGameRunning()
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

     
        // Rectangle creation, so the timer can be stopped
        private var newRectTimer: Timer?


        // Time between updates of remaining time label
        private var remainingDuration: TimeInterval = 1

        // Game timer
        // private var gameTimer: Timer?

        // Remaining time timer
        private var remainingTimer: Timer?



        // MARK: - ==== Timer Functions ====
        extension GameSceneViewController {
            
            
            
            
            //================================================
            
            //================================================
            public func startGameRunning() {
                
                // Remove all rectangles
                // Credit: https://stackoverflow.com/a/28516228
                for v in view.subviews{
                   if v is UIButton{
                      v.removeFromSuperview()
                   }
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
            private func updateRemainingTimeLabel() {
                if !gameRunning {
                    return
                }
                secondCount -= 1
                if (secondCount <= 0) {
                    stopGameRunning()
                }
            }
            
            public func stopGameRunning() {
                        
                gameInProgress = false
                // Stop the timer
                if let timer = newRectTimer { timer.invalidate() }
                // Stop the timer
                if let timer = remainingTimer { timer.invalidate() }

                // Remove the reference to the timer object
                //self.newRectTimer = nil
                        
            }
            
            func gameOver() {
                pauseGameRunning()
                
                // No game in progress, and thus no game running
                gameInProgress = false
                    
                // Indicate via the label the game is over
                gameInfoLabel.backgroundColor = .red
            }


        }





        // MARK: - ==== Rectangle Methods ====
        extension GameSceneViewController {
            private func createRectanglePair() {
                var firstRectangle = createRectangle()
                var secondRectangle = createRectangle()
                if (rectFill) {
                    secondRectangle.backgroundColor = firstRectangle.backgroundColor
                } else {
                    secondRectangle.layer.borderColor = firstRectangle.layer.borderColor
                }
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

                if(rectFill) {
                    rectangle.backgroundColor = Utility.getRandomColor(randomAlpha: randomAlpha)
                } else {
                    rectangle.layer.borderWidth = 4
                    rectangle.layer.borderColor = Utility.getRandomColor(randomAlpha: randomAlpha).cgColor
                }
                
                
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
            
            //================================================
            func removeSavedRectangles() {
                // Remove all rectangles from superview
                for rectangle in rectangles {
                    rectangle.removeFromSuperview()
                }
                
                // Clear the rectangles array
                rectangles.removeAll()
            }
            
            //================================================
            private func resumeGameRunning()
            {
                // Indicate that the game is now running
                gameRunning = true
                
                // Set the label
           

                gameInfoLabel.text = gameInfo

                // Timer to produce the pairs
                newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                                             repeats: true)
                                                    { _ in self.createRectanglePair() }
                
                // Timer to end the game, resume with the remaining time
               
                
                remainingTimer = Timer.scheduledTimer(withTimeInterval: remainingDuration,
                               repeats: true)
                { _ in self.updateRemainingTimeLabel() }
                
                /*    gameTimer = Timer.scheduledTimer(withTimeInterval: gameTimeRemaining,
                                                          repeats: false)
                                                    { _ in self.updateRemainingTimeLabel() }
     */
            }
            
            //================================================
            public func pauseGameRunning() {
                // Indicate that the game is paused
                gameRunning = false
                    
                // Set the label
                gameInfoLabel.text = gameInfo

                // Stop the timers
                newRectTimer?.invalidate()
                remainingTimer?.invalidate()
                    
                // Remove the reference to the timer objects
                newRectTimer = nil
                gameTimer    = nil
            }
            
}
