//
//  Player.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 06.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import Foundation
import SpriteKit

class Player {
    
    var scene:SKScene
    
    var shapeNode:SKShapeNode
    var physicsBody:SKPhysicsBody
    var movementSpeed:CGFloat = 10
    
    init (scene:SKScene, y:CGFloat, positionX:CGFloat) {
        self.scene = scene
        
        shapeNode = SKShapeNode(rect: CGRect(x: 0, y: y, width: 100, height: 10))
        
        shapeNode.fillColor = UIColor.yellowColor()
        shapeNode.lineWidth = 0
        shapeNode.position.x = positionX - shapeNode.frame.width / 2
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: y, width: shapeNode.frame.width, height: 10))
        
        physicsBody.affectedByGravity = false
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
        physicsBody.friction = 0
        physicsBody.restitution = 0
        physicsBody.mass = 0.1
        
        physicsBody.categoryBitMask = BitMasks.Player
        
        shapeNode.physicsBody = physicsBody
        
        scene.addChild(shapeNode)
    }
    
    func getX() -> CGFloat {
        return shapeNode.position.x
    }

    func getY() -> CGFloat {
        return shapeNode.position.y
    }
    
    func setY(positionY:CGFloat) {
        shapeNode.position.y = positionY
    }
    
    func getWidth() -> CGFloat {
        return shapeNode.frame.width
    }
    
    func move(positionX:CGFloat) {
        shapeNode.position.x = positionX
    }
    
    func velocityX(velX:CGFloat) {
        physicsBody.velocity.dx = velX * movementSpeed
    }
    
    func velocityY(velY:CGFloat) {
        physicsBody.velocity.dy = velY
    }
}