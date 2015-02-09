//
//  GameScene.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 06.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    var customSpeed:CGFloat = 20
    var movementspeed:CGFloat = 20;
    
    var lastPosition:CGFloat = 0
    var lastPlayerPosition:CGFloat = 0
    
    var playerElement:Player?
    var opponent:Player?
    var ball:Ball?
    
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
        
        backgroundColor = UIColor.blackColor()
        
        self.physicsWorld.contactDelegate = self
        
        playerElement = Player(scene: self, y: 10, positionX: center)
        opponent = Player(scene: self, y: self.frame.height - 20, positionX: center)
        ball = Ball(scene: self)
    }
    
    func didBeginContact(contact:SKPhysicsContact) {
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BitMasks.Ball && secondBody.categoryBitMask == BitMasks.World {
            println("Ball collided with world")
        } else {
            println("Detected irrelevant collision")
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        lastPosition = location.x
        lastPlayerPosition = playerElement!.getX()
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        var currentPosition = location.x
        var newLocation = (lastPlayerPosition - lastPosition + currentPosition)
        
        playerElement!.move(newLocation)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if playerElement!.getX() + playerElement!.getWidth() > self.frame.width {
            playerElement!.move(self.frame.width - playerElement!.getWidth())
        } else if playerElement!.getX() < 0 {
            playerElement!.move(0)
        }
        
        // Calculation for movement speed of opponent
        //other.position.x = ball.position.x - other.frame.width / 2
        if (opponent!.getX() + opponent!.getWidth() / 2 < ball!.getX()) {
            opponent!.velocityX(movementspeed)
        } else {
            opponent!.velocityX(-movementspeed)
        }
        
        if opponent!.getX() + opponent!.getWidth() > self.frame.width {
            opponent!.move(self.frame.width - opponent!.getWidth())
        } else if opponent!.getX() < 0 {
            opponent!.move(0)
        }
    }
}