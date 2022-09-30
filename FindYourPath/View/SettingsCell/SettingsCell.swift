//
//  SettingsCell.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    static let cellId = "settingsCellId"
    static let nibName = "SettingsCell"

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func initCell(parametr: SettingsParametr) {
        keyLabel.text = parametr.key
        valueLabel.text = String(parametr.value)
    }
    
}
