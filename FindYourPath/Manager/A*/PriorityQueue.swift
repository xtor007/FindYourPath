//
//  PriorityQueue.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 03.10.2022.
//

import Foundation

struct PriorotyQueue {
    
    private var queue = [AStarCell]()
    
    mutating func addCell(_ cell: AStarCell) {
        queue.append(cell)
    }
    
    mutating func getCell() -> AStarCell? {
        queue = queue.sorted(by: { cell1, cell2 in
            return (cell1.currentDistance!+cell1.heuristic)<(cell2.currentDistance!+cell2.heuristic)
        })
        if queue.count > 0 {
            let res = queue[0]
            queue.remove(at: 0)
            return res
        } else {
            return nil
        }
    }
    
}
