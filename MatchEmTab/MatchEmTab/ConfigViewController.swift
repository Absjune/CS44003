
import UIKit

class ConfigViewController: UIViewController {

 
    @IBOutlet weak var speedLabel: UILabel!

    @IBOutlet weak var emojiMatch: UILabel!
    @IBOutlet weak var leaderboardLabel: UILabel!
    

    var gameVC: GameSceneViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        gameVC = self.tabBarController!.viewControllers![0]
            as? GameSceneViewController
    }
    

    @IBAction func rectSpeedChange(_ sender: UISlider) {
        
        let range = (1 - Double(sender.value)) * ((gameVC!.newRectIntervalMax) - (gameVC!.newRectIntervalMin)) + gameVC!.newRectIntervalMin
        
        gameVC?.newRectInterval =  (TimeInterval( range ))
        let speed = 1 / (gameVC!.newRectInterval)
        speedLabel.text = "Speed : \(String(format: "%.2f", speed))"
    }
    
    
    @IBAction func changeBackgroundColor(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            gameVC?.view?.backgroundColor = .white
        } else {
            gameVC?.view?.backgroundColor = .blue
        }
    }
    
    
 
    
    
    
    @IBAction func switchMatchEmoji(_ sender: UISegmentedControl) {
        
        if (sender.selectedSegmentIndex == 0) {
            gameVC?.matchEmoji = "💥"
        } else {
            gameVC?.matchEmoji = "🖖"
        }
    }
    
    
    
    
    
    @IBAction func changeRectFill(_ sender: UISegmentedControl) {
        gameVC?.rectFill = (sender.selectedSegmentIndex == 0)

    }
    
    @IBAction func maxSizeChange(_ sender: UISlider) {
    }
    
}
