//
//  TreeCell.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

enum CellType {
    
    case max, mini, chance
    
    func nextType() -> CellType {
        switch self {
        case .max:
            return .mini
        case .mini:
            return .chance
        case .chance:
            return .max
        }
    }
    
}

class TreeCell {

    let type: CellType
    let labyrinth: Labyrinth
    let position: CharacterPosition
    let directionChange: [Direction]
    let currentDeep: Int
    
    var children = [TreeCell]()
    var power = 0.0
    
    init(type: CellType, labyrinth: Labyrinth, position: CharacterPosition, directionChange: [Direction], deep: Int) {
        self.type = type
        self.labyrinth = labyrinth
        self.position = position
        self.directionChange = directionChange
        self.currentDeep = deep
    }
    
    func getAnswer() -> [Direction] {
        for child in children {
            if child.power == power {
                return child.directionChange
            }
        }
        return []
    }
    
    func go() {
        if position.isPlayerKilled() {
            power = 0
            return
        }
        if position.playerCoordinates == labyrinth.finishCoordinates {
            power = 1
            return
        }
        if currentDeep == 0 {
            power = calculatePower()
            return
        }
        findChildren()
        for child in children {
            child.go()
        }
        switch type {
        case .max:
            var maxValue = 0.0
            for child in children {
                if child.power > maxValue {
                    maxValue = child.power
                }
            }
            power = maxValue
        case .mini:
            var minValue = 1.0
            for child in children {
                if child.power < minValue {
                    minValue = child.power
                }
            }
            power = minValue
        case .chance:
            var power = 0.0
            let chance = 1/Double(children.count)
            for child in children {
                power += child.power*chance
            }
            self.power = power
        }
    }
    
    private func calculatePower() -> Double {
        return 1 - 1/position.playerCoordinates.distanceTo(labyrinth.finishCoordinates)
    }
    
    private func findChildren() {
        switch type {
        case .max:
            //player move
            Direction.allDirections.forEach { direction in
                let newCoordinates = position.playerCoordinates.afterMove(direction)
                if newCoordinates.x >= 0
                    && newCoordinates.x < labyrinth.matrix[0].count
                    && newCoordinates.y >= 0
                    && newCoordinates.y < labyrinth.matrix.count
                    && labyrinth.matrix[newCoordinates.y][newCoordinates.x].patency != .wall {
                    var newPosition = position
                    newPosition.playerCoordinates = newCoordinates
                    if !newPosition.isPlayerKilled() {
                        children.append(TreeCell(type: type.nextType(), labyrinth: labyrinth, position: newPosition, directionChange: [direction], deep: currentDeep-1))
                    }
                }
            }
        case .mini:
            //bot move
            let possibleMoves = getAllDirections(forCoordinates: position.cleverKillerCoordinates)
            for move in possibleMoves {
                var newCoordinates = [Coordinates]()
                for i in 0..<move.count {
                    newCoordinates.append(position.cleverKillerCoordinates[i].afterMove(move[i]))
                }
                var newPosition = position
                newPosition.cleverKillerCoordinates = newCoordinates
                children.append(TreeCell(type: type.nextType(), labyrinth: labyrinth, position: newPosition, directionChange: move, deep: currentDeep-1))
            }
        case .chance:
            //stupid bot move
            let possibleMoves = getAllDirections(forCoordinates: position.stupidKillerCoordinates)
            for move in possibleMoves {
                var newCoordinates = [Coordinates]()
                for i in 0..<move.count {
                    newCoordinates.append(position.stupidKillerCoordinates[i].afterMove(move[i]))
                }
                var newPosition = position
                newPosition.stupidKillerCoordinates = newCoordinates
                children.append(TreeCell(type: type.nextType(), labyrinth: labyrinth, position: newPosition, directionChange: move, deep: currentDeep-1))
            }
        }
    }
    
    private func getAllDirections(forCoordinates coordinates: [Coordinates]) -> [[Direction]] {
        var preAnswer = [[Direction]]()
        for i in 0..<coordinates.count {
            var possibleDirections = [Direction]()
            
            for direction in Direction.allDirections {
                let newCoordinates = coordinates[i].afterMove(direction)
                if newCoordinates.x >= 0
                    && newCoordinates.x < labyrinth.matrix[0].count
                    && newCoordinates.y >= 0
                    && newCoordinates.y < labyrinth.matrix.count
                    && labyrinth.matrix[newCoordinates.y][newCoordinates.x].patency != .wall {
                    possibleDirections.append(direction)
                }
            }
            
            if i == 0 {
                for direction in possibleDirections {
                    let newArray = [direction]
                    preAnswer.append(newArray)
                }
            } else {
                var newPreAnswer = [[Direction]]()
                for array in preAnswer {
                    for direction in possibleDirections {
                        var newArray = array
                        newArray.append(direction)
                        newPreAnswer.append(newArray)
                    }
                }
                preAnswer = newPreAnswer
            }
        }
        return preAnswer
    }
    
}
