//
//  GameViewModel.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

enum GameStatus {
    case win, lose, game
}

class GameViewModel {
    
    var labyrinth: Labyrinth!
    var characterPosition: CharacterPosition!
    var miniMaxManager: MiniMaxManager!
    
    var gameStatus = GameStatus.game
    
    func createLabyrinth(onError: @escaping (String)->(Void)) {
        FileManager.shared.readTask { labyrinthText in
            if let labyrinth = Labyrinth(matrixText: labyrinthText) {
                self.labyrinth = labyrinth
                AStarManager.shared.initLabyrinth(self.labyrinth)
                UserDefaultsManager.shared.getValue(forKey: .treeDeep) { maxDeep in
                    self.miniMaxManager = MiniMaxManager(labyrinth: labyrinth, maxDeep: maxDeep)
                } onError: { message in
                    onError(message)
                }
            } else {
                onError("Cannot create labyrinth")
            }
        } onError: { message in
            onError(message)
        }
    }
    
    func initPosition(onError: @escaping (String)->(Void)) {
        UserDefaultsManager.shared.getValue(forKey: .cleverKillerCount) { cleverKillerCount in
            UserDefaultsManager.shared.getValue(forKey: .stupidKillerCount) { stupidKillerCount in
                var cleverKillerCoordinates = [Coordinates]()
                for _ in 0..<cleverKillerCount {
                    cleverKillerCoordinates.append(self.getRandomCoordinates())
                }
                var stupidKillerCoordinates = [Coordinates]()
                for _ in 0..<stupidKillerCount {
                    stupidKillerCoordinates.append(self.getRandomCoordinates())
                }
                self.characterPosition = CharacterPosition(
                    playerCoordinates: self.labyrinth.startCoordinates,
                    cleverKillerCoordinates: cleverKillerCoordinates,
                    stupidKillerCoordinates: stupidKillerCoordinates
                )
            } onError: { message in
                onError(message)
            }
        } onError: { message in
            onError(message)
        }
    }
    
    func getReccomendedMove() -> Direction {
        return miniMaxManager.go(withType: .max, currentPosition: characterPosition)[0]
    }
    
    func isMovePossible(direction: Direction) -> Bool {
        let newCoordinates = characterPosition.playerCoordinates.afterMove(direction)
        return newCoordinates.x >= 0
            && newCoordinates.x < labyrinth.matrix[0].count
            && newCoordinates.y >= 0
            && newCoordinates.y < labyrinth.matrix.count
            && labyrinth.matrix[newCoordinates.y][newCoordinates.x].patency != .wall
    }
    
    func movePlayer(direction: Direction) {
        characterPosition.playerCoordinates = characterPosition.playerCoordinates.afterMove(direction)
        if characterPosition.isPlayerKilled() {
            gameStatus = .lose
        }
        if characterPosition.playerCoordinates == labyrinth.finishCoordinates {
            gameStatus = .win
        }
    }
    
    func getBotMoves() -> ([Direction], [Direction]) {
        
        //clever
        let cleverBotMove = miniMaxManager.go(withType: .mini, currentPosition: characterPosition)
        var cleverBotCoordinates = [Coordinates]()
        for i in 0..<cleverBotMove.count {
            cleverBotCoordinates.append(characterPosition.cleverKillerCoordinates[i].afterMove(cleverBotMove[i]))
        }
        characterPosition.cleverKillerCoordinates = cleverBotCoordinates
        
        //stupid
        var stupidBotMove = [Direction]()
        var stupidBotCoordinates = [Coordinates]()
        for coordinates in characterPosition.stupidKillerCoordinates {
            let oldCount = stupidBotMove.count
            while oldCount == stupidBotMove.count {
                let randomDirection = Direction.allDirections[Int.random(in: 0..<4)]
                let newCoordinates = coordinates.afterMove(randomDirection)
                if newCoordinates.x >= 0
                    && newCoordinates.x < labyrinth.matrix[0].count
                    && newCoordinates.y >= 0
                    && newCoordinates.y < labyrinth.matrix.count
                    && labyrinth.matrix[newCoordinates.y][newCoordinates.x].patency != .wall {
                    stupidBotMove.append(randomDirection)
                    stupidBotCoordinates.append(newCoordinates)
                }
            }
        }
        characterPosition.stupidKillerCoordinates = stupidBotCoordinates
        
        if characterPosition.isPlayerKilled() {
            gameStatus = .lose
        }
        return (cleverBotMove, stupidBotMove)
        
    }
    
    private func getRandomCoordinates() -> Coordinates {
        let index = Int.random(in: 1...labyrinth.emptySquaresCount)
        var currentIndex = 0
        for line in labyrinth.matrix {
            for square in line {
                if square.status == nil && square.patency == .empty {
                    currentIndex += 1
                    if index == currentIndex {
                        return square.coordinates
                    }
                }
            }
        }
        return Coordinates(x: 0, y: 0)
    }
    
}
