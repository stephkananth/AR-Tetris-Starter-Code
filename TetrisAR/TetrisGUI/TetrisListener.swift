//
//  TetrisListener.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/20/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation
import ARKit

class TetrisListener: GameListener {
    
    init(sceneView: ARSCNView, home: SCNVector3) {
        // Your code here
    }
    
    func onPieceMovedOrCreated(piece: Piece) {
        // Your code here
    }
    
    func onPieceRotated(piece: Piece) {
        // Your code here
    }
    
    func onRowRemove(row: Int) {
        // Your code here
    }
    
    func onPiecePlaced(piece: Piece) {
        // Your code here
    }
    
    func onGameStateChanged(newState: GameState) {
        // Your code here
    }
    
    func onScoreChanged(score: Int) {
        // Your code here
    }
    
    func onLevelChanged(level: Int) {
        // Your code here
    }
}
