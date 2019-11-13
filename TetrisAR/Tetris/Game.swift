import Foundation

class Game {
    private var listeners: Array<GameListener> = Array()
    private var piece: Piece
    private var board: Board
    private var state: GameState
    private var timer: Timer
    private var score: Int
    private let rows: Int
    private let cols: Int
    private var level: Int = 1
    private var rowsClearedThisLevel = 0
    private var difficulty = 10 // number of rows per level
    
    public static func create(rows: Int, cols: Int) -> Game {
        return Game(rows: rows, cols: cols)
    }
    
    init(rows: Int, cols: Int) {
        board = Board(rows: rows, cols: cols)
        state = GameState.hasNotStarted
        piece = try! PieceFactory.create(row: rows - 1, col: cols / 2)
        timer = Timer()
        score = 0
        self.rows = rows
        self.cols = cols
    }
    
    public func subscribe(listener: GameListener) {
        listeners.append(listener)
    }
    
    public func start() {
        if (!isInGamePlay()) {
            setTimer(frames: 53)
            state = GameState.gamePlay
            for listener in listeners {
                listener.onGameStateChanged(newState: state)
            }
        }
    }
    
    public func getState() -> GameState {
        return self.state
    }
    
    public func pause() {
        if (state != GameState.gamePaused) {
            state = GameState.gamePaused
            for listener in listeners {
                listener.onGameStateChanged(newState: state)
            }
        }
    }
    
    public func movePieceLeft() {
        if isInGamePlay() && canMovePieceLeft() {
            piece.move(dRow: 0, dCol: -1)
            for listener in listeners {
                listener.onPieceMovedOrCreated(piece: piece)
            }
        }
    }
    
    public func movePieceRight() {
        if isInGamePlay() && canMovePieceRight() {
            piece.move(dRow: 0, dCol: 1)
            for listener in listeners {
                listener.onPieceMovedOrCreated(piece: piece)
            }
        }
    }
    
    public func movePieceDown() {
        if isInGamePlay() && canMovePieceDown() {
            piece.move(dRow: -1, dCol: 0)
            for listener in listeners {
                listener.onPieceMovedOrCreated(piece: piece)
            }
        }
    }
    
    public func rotatePiece() {
        if isInGamePlay() && canRotatePiece() {
            piece = Piece(row: piece.getCurrentRow(),
                          col: piece.getCurrentCol(),
                          color: piece.getColor(),
                          matrix: piece.rotate())
            for listener in listeners {
                listener.onPieceRotated(piece: piece)
            }
        }
    }
    
    public func startOver() {
        board = Board(rows: rows, cols: cols)
        state = GameState.gamePlay
        piece = try! PieceFactory.create(row: rows - 1, col: cols / 2)
        setTimer(frames: 53)
        level = 1
        score = 0
        for listener in listeners {
            listener.onGameStateChanged(newState: state)
            listener.onPieceMovedOrCreated(piece: piece)
        }
    }
    
    @objc private func gameLoop() throws {
        if isInGamePlay() {
            if canMovePieceDown() {
                movePieceDown()
            } else if (!isLegalPiece(board: board, newPiece: piece)) {
                state = GameState.gameOver
                for listener in listeners {
                    listener.onGameStateChanged(newState: state)
                }
                return
            } else {
                try? board.placePiece(piece: piece)
                for listener in listeners {
                    listener.onPiecePlaced(piece: piece)
                }
                
                let rowsRemoved = removeFullRows()
                updateScore(rowsRemoved: rowsRemoved)
                updateLevel(rowsRemoved: rowsRemoved)
                
                piece = try! PieceFactory.create(row: rows - 1, col: cols / 2)
                for listener in listeners {
                    listener.onPieceMovedOrCreated(piece: piece)
                }
            }
        }
    }
    
    public func hardDrop(){
        while canMovePieceDown() {
            movePieceDown()
        }
    }
    
    public func softDropStart() {
        setTimer(frames: 5)
    }
    
    public func softDropEnd() {
        setTimerByLevel()
    }
    
    private func updateScore(rowsRemoved: Int) {
        if (rowsRemoved > 0) {
            // Based on the original Nintendo scoring system
            switch rowsRemoved {
            case 1:
                score += 40
            case 2:
                score += 100
            case 3:
                score += 300
            case 4:
                score += 1200
            default:
                score += 0
            }
            for listener in listeners {
                listener.onScoreChanged(score: score)
            }
        }
    }
    
    private func updateLevel(rowsRemoved: Int) {
        rowsClearedThisLevel += rowsRemoved
        if (rowsClearedThisLevel >= difficulty) {
            level += 1
            rowsClearedThisLevel = rowsClearedThisLevel % difficulty
            setTimerByLevel()
            for listener in listeners {
                listener.onLevelChanged(level: level)
            }
        }
    }
    
    private func setTimerByLevel(){
        switch level {
        case 1:
            setTimer(frames: 53)
        case 2:
            setTimer(frames: 49)
        case 3:
            setTimer(frames: 45)
        case 4:
            setTimer(frames: 41)
        case 5:
            setTimer(frames: 37)
        case 6:
            setTimer(frames: 33)
        case 7:
            setTimer(frames: 28)
        case 8:
            setTimer(frames: 22)
        case 9:
            setTimer(frames: 17)
        case 10:
            setTimer(frames: 10)
        case 11:
            setTimer(frames: 9)
        case 12:
            setTimer(frames: 8)
        default:
            setTimer(frames: 7)
        }
    }
    
    private func setTimer(frames: Int) {
        timer.invalidate()
        let interval = 1 / 59.3 * Double(frames)
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(self.gameLoop), userInfo: nil, repeats: true)
    }
    
    private func canMovePieceDown() -> Bool {
        let newPiece = Piece(row: piece.getCurrentRow() - 1, col: piece.getCurrentCol(),
                             color: piece.getColor(), matrix: piece.getPieceMatrix())
        return isLegalPiece(board: board, newPiece: newPiece)
    }
    
    private func canMovePieceLeft() -> Bool {
        let newPiece = Piece(row: piece.getCurrentRow(), col: piece.getCurrentCol() - 1,
                             color: piece.getColor(), matrix: piece.getPieceMatrix())
        return isLegalPiece(board: board, newPiece: newPiece)
    }
    
    private func canMovePieceRight() -> Bool {
        let newPiece = Piece(row: piece.getCurrentRow(), col: piece.getCurrentCol() + 1,
                             color: piece.getColor(), matrix: piece.getPieceMatrix())
        return isLegalPiece(board: board, newPiece: newPiece)
    }
    
    private func canRotatePiece() -> Bool {
        let newPiece = Piece(row: piece.getCurrentRow(), col: piece.getCurrentCol(),
                             color: piece.getColor(), matrix: piece.rotate())
        return isLegalPiece(board: board, newPiece: newPiece)
    }
    
    private func isInGamePlay() -> Bool {
        return state == GameState.gamePlay
    }
    
    private func removeFullRows() -> Int {
        var rowsRemoved = 0
        for row in (0..<rows).reversed() {
            if try! board.isFullRow(row: row) {
                board.removeRow(row: row)
                rowsRemoved += 1
                for listener in listeners {
                    listener.onRowRemove(row: row)
                }
            }
        }
        return rowsRemoved
    }
    
    private func isLegalPiece(board: Board, newPiece: Piece) -> Bool {
        var pieceMatrix = newPiece.getPieceMatrix()
        for r in 0..<pieceMatrix.count {
            for c in 0..<pieceMatrix[0].count {
                if !pieceMatrix[r][c] {
                    continue
                }
                let newRow = newPiece.getCurrentRow() - r
                let newCol = c + newPiece.getCurrentCol()
                if newRow < 0 || newRow > rows {
                    return false
                }
                if newCol < 0 || newCol >= cols {
                    return false
                }
                if board.isBlockAt(row: newRow, col: newCol) {
                    return false
                }
            }
        }
        return true
    }
}
