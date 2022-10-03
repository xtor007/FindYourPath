//
//  AStarAlgo.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 03.10.2022.
//

import Foundation

class AStarAlgo {
    
    var labyrinth = [[AStarCell]]()
    let oldLabyrinth: Labyrinth
    
    var finishCoordinates: Coordinates?
    
    init(labyrinth: Labyrinth) {
        oldLabyrinth = labyrinth
    }
    
    func findDistance(from start: Coordinates, to finish: Coordinates) -> Int {
        
        labyrinth = []
        for line in oldLabyrinth.matrix {
            var newLine = [AStarCell]()
            for square in line {
                newLine.append(AStarCell(square: square, status: nil))
            }
            labyrinth.append(newLine)
        }
        
        labyrinth[start.y][start.x].status = .start
        labyrinth[finish.y][finish.x].status = .finish
        finishCoordinates = finish
        
        var queue = PriorotyQueue()
        labyrinth[start.y][start.x].heuristic = countHeuristic(for: start)
        labyrinth[start.y][start.x].currentDistance = 0
        queue.addCell(labyrinth[start.y][start.x])
        
        var cellOptional = queue.getCell()
        while let cell = cellOptional, cell.status != .finish {
            cell.isHere = true
            let neighbors = getAllNeighbors(forCell: cell)
            neighbors.forEach { neighbor in
                if !neighbor.isHere && neighbor.square.patency != .wall {
                    neighbor.heuristic = countHeuristic(for: neighbor.square.coordinates)
                    if neighbor.currentDistance != nil {
                        if neighbor.currentDistance! > cell.currentDistance! + 1 {
                            neighbor.currentDistance = cell.currentDistance! + 1
                        }
                    } else {
                        neighbor.currentDistance = cell.currentDistance! + 1
                        queue.addCell(neighbor)
                    }
                }
            }
            cellOptional = queue.getCell()
        }
        
        if cellOptional != nil {
            return labyrinth[finish.y][finish.x].currentDistance!
        } else {
            return 1000
        }
        
    }
    
    private func countHeuristic(for coordinates: Coordinates) -> Int {
        return (abs(coordinates.x-finishCoordinates!.x)+abs(coordinates.y-finishCoordinates!.y))
    }
    
    private func getAllNeighbors(forCell cell: AStarCell) -> [AStarCell] {
        var neighbors = [AStarCell]()
        let maxX = labyrinth[0].count-1
        let maxY = labyrinth.count-1
        for deltaX in [-1,0,1] {
            for deltaY in [-1,0,1] {
                if (deltaX != 0 || deltaY != 0) && !(deltaX != 0 && deltaY != 0) {
                    if cell.square.coordinates.x+deltaX<=maxX && cell.square.coordinates.x+deltaX>=0 && cell.square.coordinates.y+deltaY<=maxY && cell.square.coordinates.y+deltaY>=0 {
                        neighbors.append(labyrinth[cell.square.coordinates.y+deltaY][cell.square.coordinates.x+deltaX])
                    }
                }
            }
        }
        return neighbors
    }
    
}
