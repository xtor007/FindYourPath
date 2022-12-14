//
//  StartVC.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import UIKit

class StartVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playAction(_ sender: Any) {
        let gameViewModel = GameViewModel()
        let gameVC = GameVC(model: gameViewModel)
        navigationController?.show(gameVC, sender: nil)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let settingsViewModel = SettingsViewModel()
        let settingsVC = SettingsVC(model: settingsViewModel)
        navigationController?.show(settingsVC, sender: nil)
    }
    
}
