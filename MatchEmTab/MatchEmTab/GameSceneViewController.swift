
import UIKit

class GameSceneViewController: UIViewController {
        override var prefersStatusBarHidden: Bool {
            return true
        }

    required init?(coder aDecoder: NSCoder) {
        self.secondCount = Int(self.gameDuration)
        super.init(coder: aDecoder)
    }

    @IBOutlet weak var gameInfoLabel: UILabel!

    private var gameTimer: Timer?

    private var gameRunning    = false
    
    public var newRectInterval: TimeInterval = 1.2
    
    public var newRectIntervalMax: TimeInterval = 5.0
    public var newRectIntervalMin = 0.1

    public var gameDuration: TimeInterval = 12.0 + 1
    
    public var gameDurationMin: TimeInterval = 20.0
    public var gameDurationMax: TimeInterval = 1.0

    
    private var isFirstClick: Bool = true
    private var firstClickButton : UIButton!
       
        private var gameInfo : String {
            let labelText = "Time: \(secondCount) - Pairs: \(pairsCreated) - Matches: \(rectanglesMatched)"
            return labelText
        }
        
    
    var matchEmoji: String = "💥"
    var rectFill: Bool = true

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

        private var fadeDuration: TimeInterval = 0.8
        
        func removeRectangle(rectangle: UIButton) {
            let pa = UIViewPropertyAnimator(duration: fadeDuration,
                                               curve: .linear,
                                          animations: nil)
            pa.addAnimations {
                rectangle.alpha = 0.0
            }
            pa.startAnimation()
        }

        private var randomAlpha = false

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
    
        

        private var gameInProgress = false
        
    @objc func handleTouch(sender: UIButton) {
            if (gameInProgress == false) {
                return
            }
            if (isFirstClick) {
                sender.setTitle(matchEmoji, for: .normal)
                firstClickButton = sender
                isFirstClick = false
            } else {
                isFirstClick = true
                if (matchingRectangles(sender: sender)) {
                    sender.setTitle(matchEmoji, for: .normal)
                    rectanglesMatched += 1
                    removeRectangle(rectangle: sender)
                    removeRectangle(rectangle: firstClickButton)
                } else {
                    firstClickButton.setTitle("", for: .normal)
                    print("sender and first click are not same color")
                }
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
           
            if gameInProgress {
                resumeGameRunning()
            }
           }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count != 2 {
            return
        }
        
        if !gameInProgress {
            startNewGame()
            return
        }
    }
    

    func startNewGame() {
        removeSavedRectangles()

        self.secondCount = Int(self.gameDuration)
        
        rectanglesCreated = 0
        rectanglesTouched = 0
        
        gameInfoLabel.backgroundColor = .clear

        gameInProgress = true
        
        resumeGameRunning()
    }

}

    private let rectSizeMin:CGFloat =  50.0
    private let rectSizeMax:CGFloat = 150.0
    private var pairsCreated = 0
    private var rectanglesMatched = 0
    private var rectangles = [UIButton]()
    private var newRectTimer: Timer?
    private var remainingDuration: TimeInterval = 1
    private var remainingTimer: Timer?




    extension GameSceneViewController {
        public func startGameRunning() {

            for v in view.subviews{
               if v is UIButton{
                  v.removeFromSuperview()
               }
            }
            
            gameInProgress = true
            newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                         repeats: true)
                                         { _ in self.createRectanglePair() }
            
            remainingTimer = Timer.scheduledTimer(withTimeInterval: remainingDuration,
                           repeats: true)
            { _ in self.updateRemainingTimeLabel() }
        }

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
            if let timer = newRectTimer { timer.invalidate() }
            if let timer = remainingTimer { timer.invalidate() }
        }
        
        func gameOver() {
            gameInProgress = false
            gameInfoLabel.backgroundColor = .red
        }
    }

extension GameSceneViewController {
    private func createRectanglePair() {
        let firstRectangle = createRectangle()
        let secondRectangle = createRectangle()
        if (rectFill) {
            secondRectangle.backgroundColor = firstRectangle.backgroundColor
        } else {
            secondRectangle.layer.borderColor = firstRectangle.layer.borderColor
        }
        secondRectangle.frame.size.height = firstRectangle.frame.size.height
        secondRectangle.frame.size.width = firstRectangle.frame.size.width
        pairsCreated+=1
        
    }
    
    private func createRectangle() -> UIButton {
        let randSize     = Utility.getRandomSize(fromMin: rectSizeMin, throughMax: rectSizeMax)
        let randLocation = Utility.getRandomLocation(size: randSize, screenSize: view.bounds.size)
        let randomFrame  = CGRect(origin: randLocation, size: randSize)
        let rectangle = UIButton(frame: randomFrame)
        
        
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
        
        self.view.addSubview(rectangle)
        rectangle.addTarget(self,
                            action: #selector(self.handleTouch(sender:)),
                            for: .touchUpInside)
        rectangles.append(rectangle)
        view.bringSubviewToFront(gameInfoLabel!)
        return rectangle
    }
    
    func removeSavedRectangles() {
        for rectangle in rectangles {
            rectangle.removeFromSuperview()
        }
        rectangles.removeAll()
    }
    
    private func resumeGameRunning()
    {
        
        gameRunning = true
        
        gameInfoLabel.text = gameInfo
        
        newRectTimer = Timer.scheduledTimer(withTimeInterval: newRectInterval,
                                            repeats: true)
        { _ in self.createRectanglePair() }
        
        remainingTimer = Timer.scheduledTimer(withTimeInterval: remainingDuration,
                                              repeats: true)
        { _ in self.updateRemainingTimeLabel() }
        
        func pauseGameRunning() {
            gameRunning = false
            
            gameInfoLabel.text = gameInfo
            
            newRectTimer?.invalidate()
            remainingTimer?.invalidate()
            newRectTimer = nil
            gameTimer    = nil
        }
        
    }
    
}
