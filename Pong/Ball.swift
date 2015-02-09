//
//  Ball.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 09.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import Foundation
import SpriteKit

class Ball {
    
    var customSpeed:CGFloat = 15
    
    var ball:SKShapeNode
    var physicsBody:SKPhysicsBody
    var scene:SKScene
    
    init(scene:SKScene) {
        self.scene = scene

        ball = SKShapeNode(circleOfRadius: 8)
        physicsBody = SKPhysicsBody(circleOfRadius: 8)
        
        ball.fillColor = UIColor.greenColor()
        ball.lineWidth = 0
        
        ball.position.x = scene.frame.width / 2 - ball.frame.width / 2 + 10
        ball.position.y = scene.frame.height / 2 - ball.frame.height / 2
        
        physicsBody = SKPhysicsBody(circleOfRadius: 8)
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
        physicsBody.affectedByGravity = false
        physicsBody.friction = 0
        physicsBody.restitution = 1
        physicsBody.linearDamping = 0
        physicsBody.mass = 1
        
        physicsBody.categoryBitMask = BitMasks.Ball
        physicsBody.contactTestBitMask = BitMasks.World
        
        ball.physicsBody = physicsBody
        
        scene.addChild(ball)
        
        var rnX = CGFloat(arc4random_uniform(10)) * customSpeed
        var rnY = CGFloat(arc4random_uniform(100)) * customSpeed
        
        physicsBody.velocity.dx = rnX
        physicsBody.velocity.dy = rnY
    }
    
    func getX() -> CGFloat {
        return ball.position.x
    }
}