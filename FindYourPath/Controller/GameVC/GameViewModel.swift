//
//  GameViewModel.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

class GameViewModel {
    
    var labyrith: Labyrinth!
    var characterPosition: CharacterPosition!
    
    func createLabyrinth(onError: @escaping (String)->(Void)) {
        FileManager.shared.readTask { labyrinthText in
            if let labyrinth = Labyrinth(matrixText: labyrinthText) {
                self.labyrith = labyrinth
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
                    playerCoordinates: self.labyrith.startCoordinates,
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
    
    private func getRandomCoordinates() -> Coordinates {
        let index = Int.random(in: 1...labyrith.emptySquaresCount)
        var currentIndex = 0
        for line in labyrith.matrix {
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
