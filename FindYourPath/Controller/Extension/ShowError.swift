//
//  ShowError.swift
//  FindYourPath
//
//  Created by Anatoliy Khramchenko on 30.09.2022.
//

import UIKit

extension UIViewController {
    
    func showError(message: String) {
        let alertVC = UIAlertController(
                    title: "ERROR",
                    message: message,
                    preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
