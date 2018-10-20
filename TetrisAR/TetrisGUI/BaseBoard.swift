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
        
        let box = SCNBox(width: width, height: height, length: length, chamferRadius: 0)
        node.geometry = box
        box.firstMaterial?.diffuse.contents = UIImage(named: "gray-wide")
        node.position = basePosition
        scene.rootNode.addChildNode(node)
    }
}
