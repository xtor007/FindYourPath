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
        gameView.addLabyrinth(labyrith: model.labyrith)
        model.initPosition { message in
            self.showError(message: message)
        }
        gameView.addKillers(
            cleverKillerCoordinates: model.characterPosition.cleverKillerCoordinates,
            stupidKillerCoordinates: model.characterPosition.stupidKillerCoordinates
        )
    }
    
    init(model: GameViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func moveAction(_ sender: Any) {
    }
    
}
