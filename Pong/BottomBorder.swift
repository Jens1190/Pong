//
//  Border.swift
//  Pong
//
//  Created by Jens Sproede (OEV) on 06.02.15.
//  Copyright (c) 2015 OEV. All rights reserved.
//

import Foundation
import SpriteKit

class BottomBorder {
    
    var scene:SKScene
    
    var shapeNode:SKShapeNode
    var physicsBody:SKPhysicsBody
    var movementSpeed:CGFloat = 0.0
    
    init (scene:SKScene) {
        self.scene = scene
        
        shapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: scene.frame.width, height: 5))
        
        shapeNode.fillColor = UIColor.redColor()
        shapeNode.lineWidth = 0
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: shapeNode.frame.width, height: 5))
        
        physicsBody.affectedByGravity = false
        physicsBody.dynamic = true
        physicsBody.allowsRotation = false
        physicsBody.friction = 0
        physicsBody.restitution = 0
        physicsBody.mass = 0.1
        
        physicsBody.categoryBitMask = BitMasks.BottomBorder
        
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
        physicsBody.velocity.dx = velX
    }
    
    func velocityY(velY:CGFloat) {
        physicsBody.velocity.dy = velY
    }
}