//
//  GameView.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import UIKit

enum Direction {
    
    case right, down, left, up
    
    static let allDirections = [Direction.right, .down, .left, .up]
    
}

class GameView: UIView {
    
    var squareWidth: CGFloat = 0
    var squareHeight: CGFloat = 0
    
    var playerImage: UIImageView!
    var cleverKillerImages = [UIImageView]()
    var stupidKillerImages = [UIImageView]()
    
    func addLabyrinth(labyrith: Labyrinth) {
        
        //metrics
        squareHeight = frame.height / CGFloat(labyrith.matrix.count)
        squareWidth = frame.width / CGFloat(labyrith.matrix[0].count)
        
        //labyrinth
        var x: CGFloat = 0
        var y: CGFloat = 0
        labyrith.matrix.forEach { line in
            line.forEach { square in
                let imageView = UIImageView(frame: CGRect(x: x, y: y, width: squareWidth, height: squareHeight))
                switch square.patency {
                case .wall:
                    imageView.image = UIImage(named: "wall")
                case .empty:
                    imageView.image = UIImage(named: "empty")
                }
                addSubview(imageView)
                if let status = square.status {
                    let imageView2 = UIImageView(frame: CGRect(x: x, y: y, width: squareWidth, height: squareHeight))
                    switch status {
                    case .start:
                        imageView2.image = UIImage(named: "start")
                    case .finish:
                        imageView2.image = UIImage(named: "finish")
                    }
                    addSubview(imageView2)
                }
                x += squareWidth
            }
            x = 0
            y += squareHeight
        }
        addPlayer(coordinates: labyrith.startCoordinates)
    }
    
    private func addPlayer(coordinates: Coordinates) {
        playerImage = UIImageView(frame: CGRect(x: CGFloat(coordinates.x)*squareWidth, y: CGFloat(coordinates.y)*squareHeight, width: squareWidth, height: squareHeight))
        playerImage.image = UIImage(named: "player")
        addSubview(playerImage)
    }
    
    func addKillers(cleverKillerCoordinates: [Coordinates], stupidKillerCoordinates: [Coordinates]) {
        cleverKillerCoordinates.forEach { coordinates in
            let imageView = UIImageView(frame: CGRect(x: CGFloat(coordinates.x)*squareWidth, y: CGFloat(coordinates.y)*squareHeight, width: squareWidth, height: squareHeight))
            imageView.image = UIImage(named: "cleverKiller")
            addSubview(imageView)
            cleverKillerImages.append(imageView)
        }
        stupidKillerCoordinates.forEach { coordinates in
            let imageView = UIImageView(frame: CGRect(x: CGFloat(coordinates.x)*squareWidth, y: CGFloat(coordinates.y)*squareHeight, width: squareWidth, height: squareHeight))
            imageView.image = UIImage(named: "stupidKiller")
            addSubview(imageView)
            stupidKillerImages.append(imageView)
        }
    }
    
    func movePlayer(_ direction: Direction) {
        moveElement(playerImage, toDirection: direction)
    }
    
    func moveKillers(cleverDirections: [Direction], stupidDirections: [Direction]) {
        for i in 0..<cleverDirections.count {
            moveElement(cleverKillerImages[i], toDirection: cleverDirections[i])
        }
        for i in 0..<stupidDirections.count {
            moveElement(stupidKillerImages[i], toDirection: stupidDirections[i])
        }
    }
    
    private func moveElement(_ element: UIView, toDirection direction: Direction) {
        UIView.animate(withDuration: 0.2, delay: 0.1) {
            switch direction {
            case .right:
                element.frame = CGRect(
                    x: element.frame.minX+self.squareWidth,
                    y: element.frame.minY,
                    width: self.squareWidth,
                    height: self.squareHeight
                )
            case .down:
                element.frame = CGRect(
                    x: element.frame.minX,
                    y: element.frame.minY+self.squareWidth,
                    width: self.squareWidth,
                    height: self.squareHeight
                )
            case .left:
                element.frame = CGRect(
                    x: element.frame.minX-self.squareWidth,
                    y: element.frame.minY,
                    width: self.squareWidth,
                    height: self.squareHeight
                )
            case .up:
                element.frame = CGRect(
                    x: element.frame.minX,
                    y: element.frame.minY-self.squareWidth,
                    width: self.squareWidth,
                    height: self.squareHeight
                )
            }
        }
    }
    
}
