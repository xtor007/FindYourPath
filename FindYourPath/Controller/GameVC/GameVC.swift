//
//  GameVC.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import UIKit

class GameVC: UIViewController {
    
    @IBOutlet weak var gameView: GameView!
    @IBOutlet var moveButtons: [UIButton]!
    
    private let model: GameViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        model.createLabyrinth { message in
            self.showError(message: message)
        }
        gameView.addLabyrinth(labyrith: model.labyrinth)
        model.initPosition { message in
            self.showError(message: message)
        }
        gameView.addKillers(
            cleverKillerCoordinates: model.characterPosition.cleverKillerCoordinates,
            stupidKillerCoordinates: model.characterPosition.stupidKillerCoordinates
        )
        recomendMove()
    }
    
    init(model: GameViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func moveAction(_ sender: Any) {
        if let button = sender as? UIButton {
            let direction = Direction.allDirections[button.tag]
            if model.isMovePossible(direction: direction) {
                for moveButton in moveButtons {
                    moveButton.backgroundColor = .systemCyan
                }
                model.movePlayer(direction: direction)
                gameView.movePlayer(direction)
                switch model.gameStatus {
                case .win:
                    showGameResult(status: .win)
                case .lose:
                    showGameResult(status: .lose)
                case .game:
                    let (cleverKillerMoves, stupidKillerMoves) = model.getBotMoves()
                    gameView.moveKillers(cleverDirections: cleverKillerMoves, stupidDirections: stupidKillerMoves)
                    if model.gameStatus == .lose {
                        showGameResult(status: .lose)
                    } else {
                        recomendMove()
                    }
                }
            } else {
                showError(message: "Move isn't possible")
            }
        }
    }
    
    private func recomendMove() {
        let direction = model.getReccomendedMove()
        if model.gameStatus != .lose {
            moveButtons[direction.getIndex()].backgroundColor = .green
        } else {
            showGameResult(status: .lose)
        }
    }
    
    private func showGameResult(status: GameStatus) {
        let alertVC = UIAlertController(title: "Finish", message: status.getMessage(), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
}
