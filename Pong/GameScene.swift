//
//  GameScene.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 06.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var customSpeed:CGFloat = 20
    var movementspeed:CGFloat = 20;
    
    let player = SKShapeNode(rect: CGRect(x: 0, y: 20, width: 100, height: 10))
    let other = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 10))
    let ball = SKShapeNode(circleOfRadius: 15)
    
    var lastPosition:CGFloat = 0
    var lastPlayerPosition:CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        let center = self.frame.width / 2 - player.frame.width / 2
        
        /* Setup your scene here */
        let physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody = physicsBody
        backgroundColor = UIColor.blackColor()
        
        player.fillColor = UIColor.yellowColor()
        player.lineWidth = 0
        
        player.position.x = center
        
        player.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: player.frame.width, height: player.frame.height))
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.dynamic = true
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 0
        player.physicsBody?.mass = 0.1
        
        addChild(player)
        
        other.fillColor = UIColor.yellowColor()
        other.lineWidth = 0
        
        other.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: other.frame.width, height: other.frame.height))
        other.physicsBody?.affectedByGravity = false
        other.physicsBody?.dynamic = true
        other.physicsBody?.friction = 0
        other.physicsBody?.restitution = 0
        other.physicsBody?.mass = 0.1
        
        other.position.x = center
        other.position.y = self.frame.height - 30
        
        addChild(other)
        
        ball.fillColor = UIColor.greenColor()
        ball.lineWidth = 0
        
        ball.position.x = self.frame.width / 2 - ball.frame.width / 2 + 10
        ball.position.y = self.frame.height / 2 - ball.frame.height / 2
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        ball.physicsBody?.dynamic = true
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.mass = 1
        
        var rnX = CGFloat(arc4random_uniform(10)) * customSpeed
        var rnY = CGFloat(arc4random_uniform(100)) * customSpeed
        
        ball.physicsBody?.velocity.dx = rnX
        ball.physicsBody?.velocity.dy = rnY
        
        addChild(ball)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        lastPosition = location.x
        lastPlayerPosition = player.position.x
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        let location = touch.locationInNode(self)
        
        var currentPosition = location.x
        var newLocation = (lastPlayerPosition - lastPosition + currentPosition)
        
        player.position.x = newLocation
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if player.position.x + player.frame.width > self.frame.width {
            player.position.x = self.frame.width - player.frame.width
        } else if player.position.x < 0 {
            player.position.x = 0
        }
        
        // Calculation for movement speed of opponent
        //other.position.x = ball.position.x - other.frame.width / 2
        if (other.position.x + other.frame.width / 2 < ball.position.x) {
            other.physicsBody?.velocity.dx = movementspeed
        } else {
            other.physicsBody?.velocity.dx = -movementspeed
        }
        
        if other.position.x + other.frame.width > self.frame.width {
            other.position.x = self.frame.width - other.frame.width
        } else if other.position.x < 0 {
            other.position.x = 0
        }
    }
}
