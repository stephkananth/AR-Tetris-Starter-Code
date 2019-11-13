internal class Piece {
    private var row : Int
    private var col : Int
    private let color: String
    private let matrix : [[Bool]]
    
    init(row: Int, col: Int, color: String, matrix: [[Bool]]) {
        self.row = row
        self.col = col
        self.color = color
        self.matrix = matrix
    }
    
    public func getCurrentRow() -> Int {
        return row
    }
    
    public func getCurrentCol() -> Int {
        return col
    }
    
    public func getColor() -> String {
        return color
    }
    
    public func getPieceMatrix() -> [[Bool]] {
        return matrix
    }
    
    internal func move(dRow: Int, dCol: Int) {
        row += dRow
        col += dCol
    }
    
    internal func rotate() -> [[Bool]] {
        var piece: [[Bool]] = getPieceMatrix()
        var newPiece: [[Bool]] = []
        for row in 0..<piece[0].count {
            var newRow: [Bool] = []
            for col in 0..<piece.count {
                newRow.append(piece[col][row])
            }
            newPiece.append(newRow.reversed())
        }
        return newPiece
    }
}

internal class OPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[true, true], [true, true]])
    }
}

internal class LPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[true, false, false], [true, true, true]])
    }
}

internal class IPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[true,  true,  true,  true]])
    }
}

internal class JPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[false, false, true], [true, true, true]])
    }
}

internal class SPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[true, true, false], [false, true, true]])
    }
}

internal class ZPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[false, true, true], [true, true, false]])
    }
}

internal class TPiece : Piece {
    init(row: Int, col: Int, color: String) {
        super.init(row: row, col: col, color: color, matrix: [[false, true, false], [true, true, true]])
    }
}
