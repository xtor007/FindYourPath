//
//  MiniMaxManager.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

class MiniMaxManager {
    
    let labyrinth: Labyrinth
    let maxDeep: Int
    
    init(labyrinth: Labyrinth, maxDeep: Int) {
        self.labyrinth = labyrinth
        self.maxDeep = maxDeep
    }
    
    func go(withType type: CellType, currentPosition: CharacterPosition) -> [Direction] {
        let root = TreeCell(type: type, labyrinth: labyrinth, position: currentPosition, directionChange: [], deep: maxDeep, rootType: type)
        root.go(fatherPower: -1)
        return root.getAnswer()
    }
    
}
