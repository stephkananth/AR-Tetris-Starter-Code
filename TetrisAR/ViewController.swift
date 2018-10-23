//
//  ViewController.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/18/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Foundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var game: Game = Game(rows: Constants.ROWS, cols: Constants.COLS)
    var planeNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
        
        addTapGestureToSceneView()
        addSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func setUpSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        sceneView.delegate = self
    }
    
    @objc func onTap(withGestureRecognizer recognizer: UIGestureRecognizer){
        let tapLocation = recognizer.location(in: sceneView)
        
        if (game.getState() == GameState.hasNotStarted) {
            let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            guard let hitTestResult = hitTestResults.first else { return }
            
            let translation = hitTestResult.worldTransform.translation
            
            planeNode.removeFromParentNode()
            
            let listener = ARTetrisListener(sceneView: sceneView, home: SCNVector3(translation.x, translation.y, translation.z))
            game.subscribe(listener: listener)
            
            if Constants.DEBUG {
                game.subscribe(listener: ConsoleListener())
            }
            
            game.start()
        } else {
            // Your code here
        }
    }
    
    @objc func onSwipe(_ sender: UISwipeGestureRecognizer) {
        // Your code here
    }
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.onTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials = [GridMaterial()]
        
        planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        if let grid = plane.materials.first as? GridMaterial {
            grid.updateWith(anchor: anchor as! ARPlaneAnchor)
        }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}


extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

class GridMaterial: SCNMaterial {
    
    override init() {
        super.init()
        let image = UIImage(named: "grid")
        diffuse.contents = image
        diffuse.wrapS = .repeat
        diffuse.wrapT = .repeat
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateWith(anchor: ARPlaneAnchor) {
        // 1
        let mmPerMeter: Float = 1000
        let mmOfImage: Float = 100
        let repeatAmount: Float = mmPerMeter / mmOfImage
        
        // 2
        diffuse.contentsTransform = SCNMatrix4MakeScale(anchor.extent.x * repeatAmount, anchor.extent.z * repeatAmount, 1)
    }
    
}
