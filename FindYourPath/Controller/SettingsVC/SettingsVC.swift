//
//  SettingsVC.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import UIKit

class SettingsVC: UIViewController {
    
    enum Section {
        case first
    }
    
    @IBOutlet weak var settingsTable: UITableView!
    
    private let model: SettingsViewModel
    
    var dataSource: UITableViewDiffableDataSource<Section, SettingsParametr>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .light
        settingsTable.register(UINib(nibName: SettingsCell.nibName, bundle: nil), forCellReuseIdentifier: SettingsCell.cellId)
        settingsTable.delegate = self
        dataSource = UITableViewDiffableDataSource(tableView: settingsTable, cellProvider: { tableView, indexPath, model in
            if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.cellId, for: indexPath) as? SettingsCell {
                cell.initCell(parametr: model)
                return cell
            } else {
                return UITableViewCell()
            }
        })
        updateDataSource()
    }
    
    init(model: SettingsViewModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDataSource() {
        model.loadData { message in
            self.showError(message: message)
        }
        var snapshot = NSDiffableDataSourceSnapshot<Section, SettingsParametr>()
        snapshot.appendSections([.first])
        snapshot.appendItems(model.settingsParametrs)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertVC = UIAlertController(
                    title: "EDIT",
                    message: "Enter new value",
                    preferredStyle: .alert
        )
        alertVC.addTextField()
        alertVC.textFields![0].keyboardType = .numberPad
        alertVC.addAction(UIAlertAction(title: "Enter", style: .default, handler: { _ in
            self.model.changeValueInSettings(forKey: self.model.settingsKeys[indexPath.row], value: alertVC.textFields![0].text!) { message in
                self.showError(message: message)
            }
            self.updateDataSource()
        }))
        self.present(alertVC, animated: true)
    }
    
}
