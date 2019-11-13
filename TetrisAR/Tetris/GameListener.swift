protocol GameListener {
    func onPieceMovedOrCreated(piece: Piece) -> Void
    func onPieceRotated(piece: Piece) -> Void
    func onRowRemove(row: Int) -> Void
    func onPiecePlaced(piece: Piece) -> Void
    
    func onGameStateChanged(newState: GameState) -> Void
    
    func onScoreChanged(score: Int) -> Void
    func onLevelChanged(level: Int) -> Void
}
