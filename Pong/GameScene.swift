//
//  GameScene.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 06.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var collisionTop:Int = 0
    var collisionBottom:Int = 0
   
    var customSpeed:CGFloat = 20
    var movementspeed:CGFloat = 20;
    
    var lastPosition:CGFloat = 0
    var lastPlayerPosition:CGFloat = 0
    
    var playerElement:Player?
    var opponent:Player?
    var ball:Ball?
    
    var topBorder:TopBorder?
    var bottomBorder:BottomBorder?
    
    var label:SKLabelNode?
    
    var viewController:GameViewController?;
    
    init (size:CGSize, viewController:GameViewController) {
        super.init(size: size)
        self.viewController = viewController
    }
    
    override init (size:CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        let center = self.frame.width / 2
        
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = physicsBody
        
        self.physicsBody?.categoryBitMask = BitMasks.World
        self.physicsBody?.contactTestBitMask = BitMasks.Ball
        
        backgroundColor = UIColor.blackColor()
        
        self.physicsWorld.contactDelegate = self
        
        playerElement = Player(scene: self, y: 10, positionX: center)
        opponent = Player(scene: self, y: self.frame.height - 20, positionX: center)
        ball = Ball(scene: self)
        
        topBorder = TopBorder(scene: self)
        bottomBorder = BottomBorder(scene: self)
        
        label = SKLabelNode(text: "\(collisionTop)")
        label?.position.x = 20
        label?.position.y = 10
        addChild(label!)
    }
    
    func didBeginContact(contact:SKPhysicsContact) {
        let categoryMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch categoryMask {
        case BitMasks.TopBorder | BitMasks.Ball:
            collisionTop += 1
            label!.text = "\(collisionTop)"
//            println("Ball collided with top border")
//            moveBallToCenter()
        case BitMasks.BottomBorder | BitMasks.Ball:
            collisionBottom += 1
//            println("Ball collided with bottom border")
//            moveBallToCenter()
        //case BitMasks.Player | BitMasks.Ball:
            //ball?.physicsBody.velocity.dx = CGFloat(arc4random_uniform(10)) * 100
        default:    
            ()
//            println("Irrelevant collision")
        }
    }
    
    func moveBallToCenter() {
        ball?.center()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        lastPosition = location.x
        lastPlayerPosition = playerElement!.getX()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch!.locationInNode(self)
        
        let currentPosition = location.x
        let newLocation = (lastPlayerPosition - lastPosition + currentPosition)
        
        playerElement!.move(newLocation)
    }
    
    func setBallPosition(x:Double,y:Double) {
        ball!.setX(x)
        ball!.setY(y)
    }
    
    var lastUpdateTimeInterval:CFTimeInterval? = 0
   
    override func update(currentTime: CFTimeInterval) {
        let timeSinceLast:CFTimeInterval = currentTime - self.lastUpdateTimeInterval!;
        lastUpdateTimeInterval = currentTime;
        
        if playerElement!.getX() + playerElement!.getWidth() > self.frame.width {
            playerElement!.move(self.frame.width - playerElement!.getWidth())
        } else if playerElement!.getX() < 0 {
            playerElement!.move(0)
        }
        
        // Calculation for movement speed of opponent
        let posXCenter = ceil(opponent!.getX() + opponent!.getWidth() / 2);
        let ballX = ceil(ball!.getX())
        if (posXCenter < ballX - 10) {
            opponent!.velocityX(movementspeed)
        } else if (posXCenter > ballX + 10) {
            opponent!.velocityX(-movementspeed)
        } else {
            opponent!.velocityX(0)
        }
        
        if opponent!.getX() + opponent!.getWidth() > self.frame.width {
            opponent!.move(self.frame.width - opponent!.getWidth())
        } else if opponent!.getX() < 0 {
            opponent!.move(0)
        }
        
        if (viewController!.isServer) {
            let dataToSend:NSMutableData = NSMutableData.init()
            let archiver:NSKeyedArchiver = NSKeyedArchiver.init(forWritingWithMutableData: dataToSend)
            archiver.encodeDouble(Double(ball!.getX()), forKey: "x")
            archiver.encodeDouble(Double(ball!.getY()), forKey: "y")
            archiver.finishEncoding()
            
            viewController?.sendData(dataToSend)
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLast)
    }
    
    func updateWithTimeSinceLastUpdate(time: CFTimeInterval) {
        lastUpdateTimeInterval! += time
    }
}