//
//  PieceFactory.swift
//  TetrisAR
//
//  Created by Kenny Cohen on 6/18/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import Foundation

internal class PieceFactory{
    public static func create(row: Int, col: Int) throws -> Piece {
        let x = Int.random(in: 0..<7)
        var piece: Piece
        switch x {
            case 0:
                piece = OPiece(row: row, col: col, color: "yellow")
            case 1:
                piece = SPiece(row: row, col: col, color: "green")
            case 2:
                piece = ZPiece(row: row, col: col, color: "orange")
            case 3:
                piece = LPiece(row: row, col: col, color: "pink")
            case 4:
                piece = JPiece(row: row, col: col, color: "blue")
            case 5:
                piece = IPiece(row: row, col: col, color: "red")
            case 6:
                piece = TPiece(row: row, col: col, color: "cyan")
            default:
                throw GameError.IllegalArgument
        }
        return piece
    }
}
