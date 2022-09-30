//
//  UserDefaultsManager.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import Foundation

enum UserDefaultsKey: String {
    
    case cleverKillerCount, stupidKillerCount, treeDeep
    
    func getName() -> String {
        switch self {
        case .cleverKillerCount:
            return "Clever killer count"
        case .stupidKillerCount:
            return "Stupid killer count"
        case .treeDeep:
            return "Tree deep"
        }
    }
    
}

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    func getValue(forKey key: UserDefaultsKey, onSuccess: @escaping (Int)->(Void), onError: @escaping (String)->(Void)) {
        guard let data = defaults.object(forKey: key.rawValue) as? Data else {
            onError("Something is not good with defaults values")
            return
        }
        do {
            let decodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            if let decodedData = decodedData as? Int {
                onSuccess(decodedData)
            } else {
                onError("Something is not good with defaults values")
            }
        } catch {
            onError(error.localizedDescription)
        }
    }
    
    func set(value: Int, forKey key: UserDefaultsKey, onError: @escaping (String)->(Void)) {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            onError(error.localizedDescription)
        }
    }
    
}
