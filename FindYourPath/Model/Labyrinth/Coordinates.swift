//
//  Coordinates.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

struct Coordinates: Equatable {
    
    let x: Int
    let y: Int
    
    func afterMove(_ direction: Direction) -> Coordinates {
        switch direction {
        case .right:
            return Coordinates(x: x+1, y: y)
        case .down:
            return Coordinates(x: x, y: y+1)
        case .left:
            return Coordinates(x: x-1, y: y)
        case .up:
            return Coordinates(x: x, y: y-1)
        }
    }
    
    func distanceTo(_ coordinates: Coordinates) -> Double {
        return sqrt(Double((x-coordinates.x)*(x-coordinates.x) + (y-coordinates.y)*(y-coordinates.y)))
    }
    
}
