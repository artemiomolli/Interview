//
//  UserViewController.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var greetingView: UITextView!
    
    private var currentUser: User!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        currentUser = RealmManager.realmManager.getObject()
        
        emailLabel.text = currentUser.userEmail
        nameTextField.text = currentUser.userName
        genderTextField.text = currentUser.userGender
        ageTextField.text = currentUser.userAge
        greetingView.text = currentUser.userGreeting
        
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                              target: self, action: #selector(doneButtonAction))
        
        toolbarDone.items = [barBtnDone]
        ageTextField.inputAccessoryView = toolbarDone
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @IBAction func saveAction(_ sender: Any) {
        
        RealmManager.realmManager.updateObject(userMail: emailLabel.text!, userName: nameTextField.text!, userGender: genderTextField.text!, userAge: ageTextField.text!)
        
        let error = NSError(domain: "User Data is saved", code: 0, userInfo: nil)
        
        Utils.showError(error: error, onViewController: self)
        
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let firebaseManager = FirebaseManager()
        
        firebaseManager.signOut { (success, error) in
            
            SVProgressHUD.dismiss()
            
            if success {
                
                RealmManager.realmManager.delete()
                
                self.navigationController?.popToRootViewController(animated: true)
            }else {
                
                Utils.showError(error: error!, onViewController: self)
            }
        }
    }
    
    // MARK: - Helpers
    
    @objc func doneButtonAction()  {
        
        ageTextField.endEditing(true)
    }
    
    @objc private func hideKeyboard() {
        
        view.endEditing(true)
    }
}

extension UserViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
    }
}
