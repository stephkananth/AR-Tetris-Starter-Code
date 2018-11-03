//
//  TetrisAR
//  BaseBoard.swift
//
//  Created by Kenny Cohen on 6/19/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation
import ARKit

class BaseBoard {
    let x: Float
    let y: Float
    let z: Float
    var node: SCNNode
    
    init(x: Float, y: Float, z: Float) {
        self.x = x
        self.y = y
        self.z = z
        node = SCNNode()
    }
    
    func draw(scene: SCNScene) {
        let width = CGFloat(Float(Constants.COLS + 1) * Constants.BLOCK_SIZE)
        let height = CGFloat(Constants.BASE_HEIGHT)
        let length = CGFloat(Constants.BLOCK_SIZE * 2)
        let basePosition = SCNVector3(x: x, y: y - Float(height)/2, z: z)
        
        // Create a SCNBox
        // Set the box material
        // Set the node's position
        // Add the box to a node
        // Add the node to the scene
    }
}
