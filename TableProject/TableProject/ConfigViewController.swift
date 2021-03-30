//
//  ConfigViewController.swift
//  TableProject
//
//  Created by AJ Hughes on 12/13/20.
//  Copyright © 2020 AJ Hughes. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {


    @IBOutlet weak var displayLabel: UILabel!
    
    var gameVC: HollowGameSceneViewController?
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
       
       override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           gameVC = self.navigationController!.viewControllers[0]
        as? HollowGameSceneViewController
       }
       
       
       override func viewDidLoad() {
          // super.viewDidLoad()
          //gameVC = self.tabBarController!.viewControllers![0]
           //as? GameSceneViewController
       }
       
       
    @IBAction func changeBackgroundColor(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            self.view?.backgroundColor = .white
        } else {
            self.view?.backgroundColor = .blue
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
      
 
       
       /*
       @IBAction func onGameLengthChanged(_ sender: UISlider) {
           
           let range = (1 - Double(sender.value)) * ((gameVC!.gameDurationMax) - (gameVC!.gameDurationMin)) + gameVC!.gameDurationMin
           
           gameVC?.gameDuration =  (TimeInterval( range ))
           let length = (gameVC!.gameDuration)
           gameLengthLabel.text = "Game Length : \(String(format: "%.2f", length))"
           gameVC?.secondCount = Int(length)
           
           gameVC?.stopGameRunning()
           gameVC?.startGameRunning()
           
       }
    
 */


}
