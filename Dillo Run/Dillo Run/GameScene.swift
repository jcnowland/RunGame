//
//  GameScene.swift
//  Dillo Run
//
//  Created by Ryan Krueger on 12/19/16.
//  Copyright © 2016 Ryan Krueger. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
    var bg = SKSpriteNode()
    
    var highestRightTree = SKShapeNode()
    
    
    var scoreLabel = SKLabelNode()
    var backgroundSun = SKSpriteNode()
    var score = 0
    
    var timer = Timer()
    
    var gameOverLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        
        case Ball = 1
        case Wall = 2
        case Tree = 4
        case Object = 8
        
    }

    var gameOver = false
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func drawGrid() {
        
        var xAxis = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 5))
        xAxis.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        xAxis.fillColor = SKColor.black
        xAxis.zPosition = 10
        
        
        self.addChild(xAxis)
        
        var i = self.frame.midX
        while (i < self.frame.width / 2) {
            
            var ticker = SKShapeNode(rectOf: CGSize(width: 5, height: 50))
            ticker.position = CGPoint(x: i, y: self.frame.midY)
            ticker.zPosition = 10
            ticker.fillColor = SKColor.black
            
            self.addChild(ticker)
            
            i += 100
        }
        
        i = self.frame.midX
        
        while (i > -self.frame.width / 2) {
            
            var ticker = SKShapeNode(rectOf: CGSize(width: 5, height: 50))
            ticker.position = CGPoint(x: i, y: self.frame.midY)
            ticker.zPosition = 10
            ticker.fillColor = SKColor.black
            
            self.addChild(ticker)
            
            i -= 100
        }
        
        
        var yAxis = SKShapeNode(rectOf: CGSize(width: 5, height: self.frame.height))
        yAxis.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        yAxis.fillColor = SKColor.black
        yAxis.zPosition = 10
        
        self.addChild(yAxis)
        
        i = self.frame.midY
        while (i < self.frame.height / 2) {
            
            var ticker = SKShapeNode(rectOf: CGSize(width: 50, height: 5))
            ticker.position = CGPoint(x: self.frame.midX, y: i)
            ticker.zPosition = 10
            ticker.fillColor = SKColor.black
            
            self.addChild(ticker)
            
            i += 100
        }
        
        i = self.frame.midY
        
        while (i > -self.frame.height / 2) {
            
            var ticker = SKShapeNode(rectOf: CGSize(width: 50, height: 5))
            ticker.position = CGPoint(x: self.frame.midX, y: i)
            ticker.zPosition = 10
            ticker.fillColor = SKColor.black
            
            self.addChild(ticker)
            
            i -= 100
        }
        
    }
    
    
    func makeInitialTrees() {
        
        // let moveTrees = SKAction.move(by: CGVector(dx: 0, dy: -2 * self.frame.height), duration: TimeInterval(self.frame.height / 300))
        let moveTrees = SKAction.move(by: CGVector(dx: 0, dy: -2 * self.frame.height), duration: TimeInterval(2))
        let removeTrees = SKAction.removeFromParent()
        let moveAndRemoveTree = SKAction.sequence([moveTrees, removeTrees])
        
        var treeHeight = Int(self.frame.height * 1.5)
        let treeWidth = self.frame.width / 8
        let leftTreePart = SKShapeNode(rectOf: CGSize(width: Int(treeWidth), height: treeHeight))
        leftTreePart.fillColor = SKColor.brown
        var treeX = self.frame.midX
        treeX -= self.frame.width / 2
        treeX += CGFloat(treeWidth / 2)
        
        leftTreePart.position = CGPoint(x: treeX, y: self.frame.midY)
        leftTreePart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(treeWidth), height: treeHeight))
        leftTreePart.physicsBody?.restitution = 0.0
        leftTreePart.physicsBody?.isDynamic = false
        
        leftTreePart.run(moveAndRemoveTree)
        
        leftTreePart.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        leftTreePart.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        leftTreePart.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        
        
        self.addChild(leftTreePart)
        
        treeHeight += 400
        
        let rightTreePart = SKShapeNode(rectOf: CGSize(width: Int(treeWidth), height: treeHeight))
        rightTreePart.fillColor = SKColor.brown
        
        treeX = self.frame.midX + self.frame.width / 2 - CGFloat(treeWidth / 2)
        
        rightTreePart.position = CGPoint(x: treeX, y: self.frame.midY)
        
        rightTreePart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(treeWidth), height: treeHeight))
        rightTreePart.physicsBody?.restitution = 0.0
        rightTreePart.physicsBody?.isDynamic = false
        
        
        rightTreePart.run(moveAndRemoveTree)
        
        rightTreePart.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        rightTreePart.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        rightTreePart.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(rightTreePart)
        
        highestRightTree = rightTreePart
        
        
    }
    
    func makeTrees() {
        
        
        // let moveTrees = SKAction.move(by: CGVector(dx: 0, dy: -2 * self.frame.height), duration: TimeInterval(self.frame.height / 300))
        let moveTrees = SKAction.move(by: CGVector(dx: 0, dy: -2 * self.frame.height), duration: TimeInterval(2))
        let removeTrees = SKAction.removeFromParent()
        let moveAndRemoveTree = SKAction.sequence([moveTrees, removeTrees])

        var treeHeight = randRange(lower: Int(self.frame.height / 3), upper: Int(self.frame.height))
        
        
        let treeWidth = self.frame.width / 8
        let leftTreePart = SKShapeNode(rectOf: CGSize(width: Int(treeWidth), height: treeHeight))
        leftTreePart.fillColor = SKColor.brown
        var treeX = self.frame.midX
        treeX -= self.frame.width / 2
        treeX += CGFloat(treeWidth / 2)
        
        let treeY = self.frame.midY + self.frame.height / 2
        // var treeY = highestRightTree.position.y + (highestRightTree.path?.boundingBox.height)! / 2
        print("Height of highest right tree is: \(highestRightTree.path?.boundingBox.height)")
        
        leftTreePart.position = CGPoint(x: treeX, y: treeY + 400)
        leftTreePart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(treeWidth), height: treeHeight))
        leftTreePart.physicsBody?.restitution = 0.0
        leftTreePart.physicsBody?.isDynamic = false
        
        leftTreePart.run(moveAndRemoveTree)
        
        leftTreePart.physicsBody!.categoryBitMask = ColliderType.Tree.rawValue
        leftTreePart.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        leftTreePart.physicsBody!.collisionBitMask = ColliderType.Object.rawValue

        
        
        self.addChild(leftTreePart)
        
        treeHeight = randRange(lower: Int(self.frame.height / 3), upper: Int(self.frame.height))
        
        let rightTreePart = SKShapeNode(rectOf: CGSize(width: Int(treeWidth), height: treeHeight))
        rightTreePart.fillColor = SKColor.brown
        
        treeX = self.frame.midX + self.frame.width / 2 - CGFloat(treeWidth / 2)
        
        // treeY = leftTreePart.position.y + (leftTreePart.path?.boundingBox.height)! / 2
        
        rightTreePart.position = CGPoint(x: treeX, y: treeY)
        
        rightTreePart.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: Int(treeWidth), height: treeHeight))
        rightTreePart.physicsBody?.restitution = 0.0
        rightTreePart.physicsBody?.isDynamic = false
        
        
        rightTreePart.run(moveAndRemoveTree)
        
        rightTreePart.physicsBody!.categoryBitMask = ColliderType.Tree.rawValue
        rightTreePart.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        rightTreePart.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(rightTreePart)
        
        highestRightTree = rightTreePart
 
        
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact between \(contact.bodyA.categoryBitMask) and \(contact.bodyB.categoryBitMask)")
        
        if contact.bodyA.categoryBitMask == ColliderType.Tree.rawValue || contact.bodyB.categoryBitMask == ColliderType.Tree.rawValue {
            print("New contact")
            print("Ball hit tree")
            
            score += 1
            
            scoreLabel.text = String(score)
            
        } else if contact.bodyA.categoryBitMask == ColliderType.Object.rawValue || contact.bodyB.categoryBitMask == ColliderType.Object.rawValue {
            
            // Do nothing
            
        } else if contact.bodyA.categoryBitMask == ColliderType.Wall.rawValue || contact.bodyB.categoryBitMask == ColliderType.Wall.rawValue {
            
            print("Hit wall")
            self.speed = 0
            
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 30
            
            gameOverLabel.text = "Game Over! Tap to play again."
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
        }
        
        
        
    }
    
    
    // Like viewDidLoad(). Means the scene has appeared on the view controller
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
    }
    
    func setupGame() {
    
        // makeInitialTrees()
        drawGrid()
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.makeTrees), userInfo: nil, repeats: true)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let bgTexture = SKTexture(imageNamed: "cartoon_sky.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: 0, dy: -bgTexture.size().height), duration: 2)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: 0, dy: bgTexture.size().height), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: self.frame.midX, y: bgTexture.size().height * i)
            
            bg.size.width = self.frame.width
            
            bg.run(moveBGForever)
            
            bg.zPosition = -1
            
            self.addChild(bg)
            
            i += 1
        }
        
        
        let treetopTexture = SKTexture(imageNamed: "bush_art.png")
        
        
        let leftTreetop = SKSpriteNode(texture: treetopTexture, size: CGSize(width: 200, height: 132))
        
        leftTreetop.position = CGPoint(x: self.frame.midX - self.frame.width / 2 + treetopTexture.size().width / 2, y: self.frame.midY + self.frame.height / 2 - treetopTexture.size().height)
        
        self.addChild(leftTreetop)
        
        let rightTreetop = SKSpriteNode(texture: treetopTexture, size: CGSize(width: 200, height: 132))
        
        rightTreetop.position = CGPoint(x: self.frame.midX + self.frame.width / 2 - treetopTexture.size().width / 2, y: self.frame.midY + self.frame.height / 2 - treetopTexture.size().height)
        
        self.addChild(rightTreetop)
        
        let ballTexture0 = SKTexture(imageNamed: "ball0.png")
        let ballTexture1 = SKTexture(imageNamed: "ball1.png")
        let ballTexture2 = SKTexture(imageNamed: "ball2.png")
        let ballTexture3 = SKTexture(imageNamed: "ball3.png")
        let ballTexture4 = SKTexture(imageNamed: "ball4.png")
        let ballTexture5 = SKTexture(imageNamed: "ball5.png")
        let ballTexture6 = SKTexture(imageNamed: "ball6.png")
        
        let rolling = SKAction.animate(with: [ballTexture0, ballTexture1, ballTexture2, ballTexture3, ballTexture4, ballTexture5, ballTexture6], timePerFrame: 0.5)
        
        let makeBallRoll = SKAction.repeatForever(rolling)
        
        
        ball = SKSpriteNode(texture: ballTexture0)
        
        ball.position = CGPoint(x: self.frame.midX + self.frame.width / 2 - self.frame.width / 8, y: self.frame.midY)
        ball.run(makeBallRoll)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballTexture0.size().height / 2)
        
        
        ball.physicsBody!.contactTestBitMask = ColliderType.Tree.rawValue
        ball.physicsBody!.categoryBitMask = ColliderType.Ball.rawValue
        ball.physicsBody!.collisionBitMask = ColliderType.Tree.rawValue | ColliderType.Object.rawValue
        
        ball.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(ball)
        
        
        let leftWall = SKNode()
        
        leftWall.position = CGPoint(x: -self.frame.width / 2 + self.frame.width / 8 - 30, y: self.frame.midY)
        
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        
        leftWall.physicsBody!.isDynamic = false
        leftWall.physicsBody!.restitution = 0.0
        
        leftWall.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        leftWall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        leftWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        leftWall.physicsBody!.usesPreciseCollisionDetection = true
        
        self.addChild(leftWall)
        
        let rightWall = SKNode()
        
        rightWall.position = CGPoint(x: self.frame.width / 2 - self.frame.width / 8 + 30, y: self.frame.midY)
        
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.frame.height))
        
        rightWall.physicsBody!.isDynamic = false
        rightWall.physicsBody!.restitution = 0.0
        
        
        rightWall.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue
        rightWall.physicsBody!.categoryBitMask = ColliderType.Wall.rawValue
        rightWall.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        rightWall.physicsBody!.usesPreciseCollisionDetection = true
        
        
        self.addChild(rightWall)
        
        
        let backgroundSunTexture = SKTexture(imageNamed: "cartoon_sun.png")
        backgroundSun = SKSpriteNode(texture: backgroundSunTexture, size: CGSize(width: 300, height: 290))
        backgroundSun.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 80)
        backgroundSun.zPosition = 2
        self.addChild(backgroundSun)
        
        scoreLabel.fontName = "Menlo"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.fontColor = UIColor.black
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 105)
        scoreLabel.zPosition = 3
        self.addChild(scoreLabel)
        
        
        
        
        
    }
    
    // When the user touches the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (gameOver == false) {
            ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            ball.physicsBody!.restitution = 0.0
            
            if (ball.position.x < self.frame.midX) {
                
                ball.physicsBody!.applyImpulse(CGVector(dx: self.frame.width - 100, dy: 0))
                self.physicsWorld.gravity = CGVector(dx: 100, dy: 0)
            } else {
                ball.physicsBody!.applyImpulse(CGVector(dx: -self.frame.width + 100, dy: 0))
                self.physicsWorld.gravity = CGVector(dx: -100, dy: 0)
            }
        } else {
            gameOver = false
            
            score = 0
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
        }
        
        
    }
    

    
    // Called several times a second - check for collisions, move items on game scene, do anything that needs to happen continuosly throughout the game
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
