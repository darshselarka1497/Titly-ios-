//
//  GameViewController.swift
//  Tilty

// Jack Joliet (jrjoliet@iu.edu) • Gavin Steever (ggsteeve@iu.edu) Tilty Jack Johnson (jj266@iu.edu) • Darsh Selarka (dselarka@iu.edu) (5/02/20)

//timer code found on page 538 of the textbook.
import UIKit
import CoreMotion
import SpriteKit

class GameViewController: UIViewController {
    
    let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var model = myAppDelegate.model
    let motion = CMMotionManager()
    var timer: Timer?
    var scene: SKScene?
    
    var ball = SKShapeNode()
    var topLeft = SKShapeNode()
    var topRight = SKShapeNode()
    var bottomLeft = SKShapeNode()
    var bottomRight = SKShapeNode()
    var lblPoint = SKLabelNode(text: "0")
    var lblTimer = SKLabelNode(text: "0.00")
    var lblEndGame = SKLabelNode(text: "")
    var lblFinalScore = SKLabelNode(text: "")
    var gameTimer: Timer?
    var gametime = 0.0
    var totaltime = 0.0
    var speedUp = 600.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let skView = self.view as? SKView {
            
            self.scene = SKScene(size: skView.bounds.size)
            self.scene?.backgroundColor = SKColor.systemPink
            self.createLabels()
            self.createBall()
            self.createSquares()
            self.setSquares(target: self.model.target)
            
            skView.presentScene(scene)
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1.0 / 100.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        
        self.startAccelerometers();
    }
    
    @objc func fireTimer(){
        gametime += 1.0
        totaltime += 1.0
    }
    
    @objc func goBack(){
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    func addPoint() {
        let newTarget = self.model.addPoint()
        self.lblPoint.text = "\(self.model.points)"
        self.setSquares(target: newTarget)
    }
    
    func endGame() {
        self.gameTimer?.invalidate()
        self.timer?.invalidate()
        self.lblPoint.text = ""
        self.lblTimer.text = ""
        self.lblEndGame.text = "GAME OVER!"
        self.lblFinalScore.text = "Final Score: \(self.model.points)"
        self.model.gameOver()
        print(self.model.points)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(goBack), userInfo: nil, repeats: false)
    }
    
    func checkPosition() {
        let x = self.ball.position.x
        let y = self.ball.position.y
        if(gametime >= speedUp){
            self.motion.stopAccelerometerUpdates();
            self.ball.position = CGPoint(x: x, y: y)
        }
        else{
            if ((x < 175) && (y > self.view.bounds.height - 175)) {
                if(model.isInSquare(square: 0)) {
                    self.addPoint()
                    gametime = 0
                    if(speedUp > 200.0){
                        speedUp = speedUp - 10.0;
                    }
                }
            } else if ((x > self.view.bounds.width - 175) && (y > self.view.bounds.height - 175)) {
                if(model.isInSquare(square: 1)) {
                    self.addPoint()
                    gametime = 0
                    if(speedUp > 200.0){
                        speedUp = speedUp - 10.0;
                    }
                }
            } else if ((x < 175) && (y < 175)) {
                if(model.isInSquare(square: 2)) {
                    self.addPoint()
                    gametime = 0
                    if(speedUp > 200.0){
                        speedUp = speedUp - 10.0;
                    }
                }
                
            } else if ((x > self.view.bounds.width - 175) && (y < 175)) {
                if(model.isInSquare(square: 3)) {
                    self.addPoint()
                    gametime = 0
                    if(speedUp > 200.0){
                        speedUp = speedUp - 10.0;
                    }
                }
            }
            
        }
    }
    
    func startAccelerometers() {
       // Make sure the accelerometer hardware is available.
       if self.motion.isAccelerometerAvailable {
          self.motion.accelerometerUpdateInterval = 1.0 / 60.0  // 60 Hz
          self.motion.startAccelerometerUpdates()

          // Configure a timer to fetch the data.
          self.timer = Timer(fire: Date(), interval: (1.0/60.0),
                repeats: true, block: { (timer) in
             // Get the accelerometer data.
             if let data = self.motion.accelerometerData {
                if(self.gametime >= self.speedUp){
                    RunLoop.current.cancelPerformSelectors(withTarget: self)
                    self.endGame()
                } else{
                    let currentX = self.ball.position.x
                    let x = data.acceleration.x
                    let nextX = currentX + CGFloat(x * 75)
                    let currentY = self.ball.position.y
                    let y = data.acceleration.y
                    let nextY = currentY + CGFloat(y * 75)

                    self.ball.position = CGPoint(x: nextX > self.view.bounds.width - 25 ? self.view.bounds.width - 25 : nextX < 25 ? 25 : nextX, y: nextY > self.view.bounds.height - 25 ? self.view.bounds.height - 25 : nextY < 25 ? 25 : nextY)
                    
                    let seconds = self.gametime / 100.0
                    self.lblTimer.text = "\(seconds)"
                    self.checkPosition()
                }
             }
          })

          // Add the timer to the current run loop.
        RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
       }
    }
    
    func createSquares() {
        self.topLeft = SKShapeNode(rectOf: CGSize(width: 150, height: 150))
        self.topLeft.position = CGPoint(x: 75, y: self.view.bounds.height - 75)
        self.scene!.addChild(self.topLeft)
        self.topRight = SKShapeNode(rectOf: CGSize(width: 150, height: 150))
        self.topRight.position = CGPoint(x: self.view.bounds.width - 75, y: self.view.bounds.height - 75)
        self.scene!.addChild(self.topRight)
        self.bottomLeft = SKShapeNode(rectOf: CGSize(width: 150, height: 150))
        self.bottomLeft.position = CGPoint(x: 75, y: 75)
        self.scene!.addChild(self.bottomLeft)
        self.bottomRight = SKShapeNode(rectOf: CGSize(width: 150, height: 150))
        self.bottomRight.position = CGPoint(x: self.view.bounds.width - 75, y: 75)
        self.scene!.addChild(self.bottomRight)
    }
    
    func createBall() {
        self.ball = SKShapeNode(circleOfRadius: 25)
        self.ball.fillColor = SKColor.white
        self.ball.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        self.ball.zPosition = 1
        self.ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        self.ball.physicsBody?.allowsRotation = false
        self.ball.physicsBody?.linearDamping = 0.5
        self.ball.physicsBody?.affectedByGravity = false
        
        self.scene!.addChild(self.ball)
    }
    
    func setSquares(target: Int) {
        let targetColor = SKColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue:  CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        let otherColor = SKColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue:  CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
        
        self.topLeft.fillColor = otherColor
        self.topRight.fillColor = otherColor
        self.bottomLeft.fillColor = otherColor
        self.bottomRight.fillColor = otherColor
        
        switch(target) {
            case 0:
                self.topLeft.fillColor = targetColor
            case 1:
                self.topRight.fillColor = targetColor
            case 2:
                self.bottomLeft.fillColor = targetColor
            case 3:
                self.bottomRight.fillColor = targetColor
            default:
                return
        }
    }
    
    func createLabels() {
        self.lblPoint.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 20)
        self.lblPoint.color = SKColor.white
        self.scene!.addChild(self.lblPoint)
        self.lblTimer.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 20)
        self.lblTimer.fontSize = 20
        self.lblTimer.color = SKColor.white
        self.scene!.addChild(self.lblTimer)
        self.lblEndGame.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 + 20)
        self.lblEndGame.color = SKColor.white
        self.scene!.addChild(self.lblEndGame)
        self.lblFinalScore.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 - 20)
        self.lblFinalScore.fontSize = 20
        self.lblFinalScore.color = SKColor.white
        self.scene!.addChild(self.lblFinalScore)
    }

}
