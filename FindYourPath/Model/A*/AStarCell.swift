//
//  AStarCell.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 03.10.2022.
//

import Foundation

enum AStarCellStatus {
    case start, finish
}

class AStarCell {
    
    let square: Square
    var status: AStarCellStatus?
    
    var isHere = false
    var currentDistance: Int?
    var heuristic = 0
    
    init(square: Square, status: AStarCellStatus?) {
        self.square = square
        self.status = status
    }
    
}
