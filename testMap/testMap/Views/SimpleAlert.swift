//
//  SimpleAlert.swift
//  testMap
//
//  Created by Даниил Ермоленко on 18.10.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String?, url: URL?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
            if let url = url {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

}
