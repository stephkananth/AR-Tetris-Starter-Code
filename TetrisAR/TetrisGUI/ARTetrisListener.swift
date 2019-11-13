import Foundation
import ARKit

class ARTetrisListener: GameListener {
    
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
        // Optional
    }
    
    func onLevelChanged(level: Int) {
        // Your code here
        // Optional
    }
}
