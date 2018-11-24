//
//  ChooseLoginViewController.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import FacebookLogin
import SVProgressHUD


class ChooseLoginViewController: UIViewController {
    
    let manager: FirebaseManager = FirebaseManager()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
         self.navigationController?.isNavigationBarHidden = true
        
        if let _ = RealmManager.realmManager.getObject() {
            
            self.performSegue(withIdentifier: Segues.startToMainMenu, sender: self)
        }
        
    }
    // MARK: - Actions
    
    @IBAction func loginWithFBAction(_ sender: Any) {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions:[.publicProfile, .email], viewController: self) { result in
            
            switch result {
                
            case .failed(let error):
                
                Utils.showError(error: error, onViewController: self)
                
            case .cancelled:
                
                break
                
            case .success ( _, _, let accessToken):
                
                print(accessToken.authenticationToken)
                
                SVProgressHUD.show()
                
                self.manager.loginWithFacebook(faceboolAccessToken: accessToken.authenticationToken, completion: { (success, error) in
                    
                    SVProgressHUD.dismiss()
                    
                    if success {
                        
                        self.performSegue(withIdentifier: Segues.startToMainMenu, sender: self)
                    }else if let currentError = error {
                        
                        Utils.showError(error: currentError, onViewController: self)
                    }
                })
            }
        }
        
    }
}
