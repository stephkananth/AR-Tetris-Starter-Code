//
//  TextViews.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/23/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation
import UIKit
import ARKit

class TextViews {
    private var centerText: UILabel
    private var scoreText: UILabel
    private var levelText: UILabel
    private var sceneView: ARSCNView
    
    init(sceneView: ARSCNView) {
        // Your code here
    }
    
    public func setScore(score: Int) {
        scoreText.text = String(score)
    }
    
    public func setCenterText(text: String) {
        centerText.text = text
    }
    
    public func setLevel(level: Int) {
        levelText.text = String(level)
    }
}
