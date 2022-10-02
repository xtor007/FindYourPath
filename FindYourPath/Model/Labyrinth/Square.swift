//
//  Square.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

enum Patency {
    case wall, empty
}

enum SquareStatus {
    case start, finish
}

struct Square {
    let coordinates: Coordinates
    let patency: Patency
    let status: SquareStatus?
}
