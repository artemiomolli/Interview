//
//  LoginViewController.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureBackPopButton()
        
        navigationController?.navigationBar.tintColor = UIColor.darkText
        
        navigationController?.isNavigationBarHidden = false
    }
        
    // MARK: - Actions
    
    @IBAction func signInAction(_ sender: Any) {
        
        
        if passwordTextField.text!.count > 6, isValidEmail(email: emailTextField.text!) {
            
            SVProgressHUD.show()
            
            let firebaseManager = FirebaseManager()
            
            firebaseManager.loginWithEmailAndPassword(email: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
                
                SVProgressHUD.dismiss()
                
                if success {
                    
                    self.performSegue(withIdentifier: Segues.signInToMain, sender: self)
                }else {
                    
                    Utils.showError(error: error!, onViewController: self)
                }
            }
        }else {
            
            let error = NSError(domain: "Error small password", code: 0, userInfo: nil)
            
            Utils.showError(error: error, onViewController: self)
            
        }
    }
    
    
    // MARK: - Helpers
    
    func isValidEmail(email:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - Keyboard
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
       
                self.view.frame.origin.y -= keyboardSize.height
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
          
                self.view.frame.origin.y += keyboardSize.height
            
        }
    }
    
    @objc private func hideKeyboard() {
        
        view.endEditing(true)
    }
}

extension LoginViewController:  UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
}
