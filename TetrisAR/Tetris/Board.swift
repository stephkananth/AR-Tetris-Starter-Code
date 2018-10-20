//
//  Board.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/18/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//
import Foundation

class Board {
    private var board: [[String?]] = []
    private var rows: Int
    private var cols: Int
    
    init(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        self.board = createBoard(rows: rows, cols: cols)
    }
    
    private func createBoard(rows: Int, cols: Int) -> [[String?]] {
        var newBoard: [[String?]] = []
        for _ in 0..<rows {
            var newRow: [String?] = []
            for _ in 0..<cols {
                newRow.append(nil)
            }
            newBoard.append(newRow)
        }
        return newBoard
    }
    
    public func isBlockAt(row: Int, col: Int) -> Bool {
        return board[row][col] != nil
    }
    
    public func getBlockColorAt(row: Int, col: Int) -> String {
        return board[row][col]!
    }
    
    internal func placePiece(piece: Piece) throws {
        for row in 0..<piece.getPieceMatrix().count {
            for col in 0..<piece.getPieceMatrix()[0].count {
                let currentRow = piece.getCurrentRow() - row
                let currentCol = piece.getCurrentCol() + col
                if (piece.getPieceMatrix()[row][col]) {
                    if isBlockAt(row: currentRow, col: currentCol) {
                        throw GameError.IllegalPiecePlacement
                    }
                    board[currentRow][currentCol] = piece.getColor()
                }
            }
        }
    }
    
    internal func isFullRow(row: Int) throws -> Bool{
        if (row < 0 || row > rows) {
            throw GameError.IllegalArgument
        }
        for col in 0..<cols {
            if board[row][col] == nil {
                return false
            }
        }
        return true
    }
    
    internal func removeRow(row: Int) {
        board.remove(at: row)
        var newRow: [String?] = []
        for _ in 0..<cols {
            newRow.append(nil)
        }
        board.append(newRow)
    }
}
