//
//  CharacterPosition.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

struct CharacterPosition {
    
    var playerCoordinates: Coordinates
    var cleverKillerCoordinates: [Coordinates]
    var stupidKillerCoordinates: [Coordinates]
    
    func isPlayerKilled() -> Bool {
        return cleverKillerCoordinates.contains { coordinates in
            return coordinates == playerCoordinates
        } || stupidKillerCoordinates.contains(where: { coordinates in
            return coordinates == playerCoordinates
        })
    }
    
}
