//
//  SettingsViewModel.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import Foundation

class SettingsViewModel {
    
    let settingsKeys = [UserDefaultsKey.stupidKillerCount, .cleverKillerCount, .treeDeep]
    private(set) var settingsParametrs = [SettingsParametr]()
    
    func loadData(onError: @escaping (String) -> (Void)) {
        settingsParametrs = []
        settingsKeys.forEach { key in
            UserDefaultsManager.shared.getValue(forKey: key) { value in
                self.settingsParametrs.append(SettingsParametr(key: key.getName(), value: value))
            } onError: { message in
                onError(message)
            }
        }
    }
    
    func changeValueInSettings(forKey key: UserDefaultsKey, value: String, onError: @escaping (String) -> (Void)) {
        if let number = Int(value) {
            UserDefaultsManager.shared.set(value: number, forKey: key, onError: onError)
        } else {
            onError("It isn't number")
        }
    }
    
}
