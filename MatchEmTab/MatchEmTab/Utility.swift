
import UIKit

class Utility: NSObject {

        let ri = Int.random(in: 0 ... 99)
        let rd = Double.random(in: 0.0 ... 1.0)
        static func randomFloatZeroThroughOne() -> CGFloat {

            let randomFloat = CGFloat.random(in: 0 ... 1.0)
                
            return randomFloat
        }
    
        static func getRandomSize(fromMin min: CGFloat, throughMax max: CGFloat) -> CGSize {
            let randWidth  = randomFloatZeroThroughOne() * (max - min) + min
            let randHeight = randomFloatZeroThroughOne() * (max - min) + min
            let randSize = CGSize(width: randWidth, height: randHeight)
                
            return randSize
        }

        static func getRandomLocation(size rectSize: CGSize, screenSize: CGSize) -> CGPoint {

            let screenWidth  = screenSize.width
            let screenHeight = screenSize.height
                
            let rectX = randomFloatZeroThroughOne() * (screenWidth  - rectSize.width)
            let rectY = randomFloatZeroThroughOne() * (screenHeight - rectSize.height)
            let location = CGPoint(x: rectX, y: rectY)
                
            return location
        }
    
        static func getRandomColor(randomAlpha: Bool) -> UIColor {
            let randRed   = randomFloatZeroThroughOne()
            let randGreen = randomFloatZeroThroughOne()
            let randBlue  = randomFloatZeroThroughOne()

            var alpha:CGFloat = 1.0
            if randomAlpha {
                alpha = randomFloatZeroThroughOne()
            }
                
            return UIColor(red: randRed, green: randGreen, blue: randBlue, alpha: alpha)
        }
    }
