//
//  Labyrinth.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

struct Labyrinth {
    
    let startCoordinates: Coordinates
    let finishCoordinates: Coordinates
    let matrix: [[Square]]
    let emptySquaresCount: Int
    
    init?(matrixText: String) {
        
        //create character matrix
        var matrix = [[Character]]()
        let lines = matrixText.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
        let lineSize = lines[0].count
        lines.forEach { line in
            var lineOfChars = [Character]()
            if line.count != lineSize {
                return
            }
            let chars = line.components(separatedBy: ",")
            chars.forEach { char in
                if char.count != 1 {
                    return
                }
                lineOfChars.append(Character(char))
            }
            matrix.append(lineOfChars)
        }
        
        //init
        var emptySquaresCount = 0
        var x = 0
        var y = 0
        var startCoordinates: Coordinates?
        var finishCoordinates: Coordinates?
        var newMatrix = [[Square]]()
        for line in matrix {
            var lineOfCell = [Square]()
            for char in line {
                switch char {
                case "0":
                    lineOfCell.append(Square(coordinates: Coordinates(x: x, y: y), patency: .wall, status: nil))
                case "1":
                    lineOfCell.append(Square(coordinates: Coordinates(x: x, y: y), patency: .empty, status: nil))
                    emptySquaresCount += 1
                case "A":
                    lineOfCell.append(Square(coordinates: Coordinates(x: x, y: y), patency: .empty, status: .start))
                    if startCoordinates != nil {
                        return nil
                    }
                    startCoordinates = Coordinates(x: x, y: y)
                case "B":
                    lineOfCell.append(Square(coordinates: Coordinates(x: x, y: y), patency: .empty, status: .finish))
                    if finishCoordinates != nil {
                        return nil
                    }
                    finishCoordinates = Coordinates(x: x, y: y)
                default:
                    return nil
                }
                x += 1
            }
            y += 1
            x = 0
            newMatrix.append(lineOfCell)
        }
        self.matrix = newMatrix
        if let startCoordinates = startCoordinates {
            self.startCoordinates = startCoordinates
        } else {
            return nil
        }
        if let finishCoordinates = finishCoordinates {
            self.finishCoordinates = finishCoordinates
        } else {
            return nil
        }
        self.emptySquaresCount = emptySquaresCount
    }
    
}
