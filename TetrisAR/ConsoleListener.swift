import Foundation

class ConsoleListener : GameListener {
    func onPieceMovedOrCreated(piece: Piece) {
        print("Piece moved or created: ")
        print(piece)
    }
    
    func onRowRemove(row: Int) {
        print("Row removed " + String(row))
    }
    
    func onPiecePlaced(piece: Piece) {
        print("Piece placed")
    }
    
    func onGameStateChanged(newState: GameState) {
        print("Game state changed")
    }
    
    func onPieceRotated(piece: Piece) {
        print("Piece rotated")
    }
    
    func onScoreChanged(score: Int) {
        print("Score: " + String(score))
    }
    
    func onLevelChanged(level: Int) {
        print("Level: " + String(level))
    }
    
    
}
