//
//  Utils.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    // MARK: - Error handler
    
    class func showError(error:Error, onViewController viewController:UIViewController) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}

protocol CustomNavigationBar {
    
    func popAction()
}

extension UIViewController:CustomNavigationBar {
    
    @objc func popAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension CustomNavigationBar where Self: UIViewController {
    
    func configureBackPopButton() {
        
        let backButton = UIBarButtonItem(image: UIImage(named:"ic_ab_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(popAction))
        
        self.navigationItem.leftBarButtonItem = backButton
    }
}
