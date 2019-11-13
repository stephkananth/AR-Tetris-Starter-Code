import Foundation
import UIKit
import SceneKit
import ARKit

class Block {
    var x: Float
    var y: Float
    var z: Float
    var color: String
    let node: SCNNode
    var box: SCNBox?
    
    init(x: Float, y: Float, z: Float, color: String){
        self.x = x
        self.y = y
        self.z = z
        self.color = color
        node = SCNNode()
        box = SCNBox(width: CGFloat(Constants.BLOCK_SIZE), height: CGFloat(Constants.BLOCK_SIZE), length: CGFloat(Constants.BLOCK_SIZE), chamferRadius: 0)
        node.geometry = box
        box?.firstMaterial?.diffuse.contents = UIImage(named: self.color)
    }
    
    func draw(scene: SCNScene){
        node.position = SCNVector3(x + Constants.BLOCK_SIZE / 2, y - Constants.BLOCK_SIZE / 2, z)
        scene.rootNode.addChildNode(node)
    }
    
    func destroy(){
        node.cleanup()
    }
    
    func setLocation(location: SCNVector3) {
        x = location.x
        y = location.y
        z = location.z
        node.position = SCNVector3(x + Constants.BLOCK_SIZE / 2, y - Constants.BLOCK_SIZE / 2, z)
    }
    
    func moveDown(){
        y -= Constants.BLOCK_SIZE
        node.position = SCNVector3(x + Constants.BLOCK_SIZE / 2, y - Constants.BLOCK_SIZE / 2, z)
    }
}

extension SCNNode {
    func cleanup() {
        self.geometry = nil
        self.isHidden = true
        for child in childNodes {
            child.cleanup()
        }
        geometry = nil
        self.removeFromParentNode()
    }
}
