//
//  FileManager.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 02.10.2022.
//

import Foundation

class FileManager {
    
    static let shared = FileManager()
    
    private init() {}
    
    func readTask(onSuccess: @escaping (String)->(Void), onError: @escaping (String)->(Void)) {
        if let fileURL = Bundle.main.url(forResource: "LabyrinthTask", withExtension: "txt") {
            if let text = try? String(contentsOf: fileURL) {
                onSuccess(text)
            } else {
                onError("Cannot read text")
            }
        } else {
            onError("Cannot find url")
        }
    }
    
}
