//
//  AStarManager.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 03.10.2022.
//

import Foundation

class AStarManager {
    
    static let shared = AStarManager()
    
    var algo: AStarAlgo?
    
    private init() {}
    
    func initLabyrinth(_ labyrinth: Labyrinth) {
        algo = AStarAlgo(labyrinth: labyrinth)
    }
    
    func getDistance(from start: Coordinates, to finish: Coordinates) -> Int {
        return algo!.findDistance(from: start, to: finish)
    }
    
}
