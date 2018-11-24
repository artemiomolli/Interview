//
//  FirebaseManager.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FacebookCore

class FirebaseManager: NSObject {
    
    // MARK: - Auth methods
    
    func loginWithEmailAndPassword(email:String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if let _ = error {
                
                Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
                    
                    if error != nil {
                        
                        completion(false, error)
                    }else {
                        
                        self.helperForLogin(email: email, password: password, completion: completion)
                    }
                }
            }else {
                
                self.helperForLogin(email: email, password: password, completion: completion)
            }
        }
    }
    
    func loginWithFacebook (faceboolAccessToken: String,completion: @escaping (Bool, Error?) -> Void) {
        
        let credential = FacebookAuthProvider.credential(withAccessToken:faceboolAccessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            
            if let error = error {
                
                completion(false, error)
            } else {
                
                GraphRequest(graphPath: "me", parameters: ["fields": "name, first_name, email"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion).start({ (response, result) in
                    
                    switch result {
                        
                    case .failed(let errorFB):
                        
                        completion(false, errorFB)
                    case .success (let value):
                        
                        if let data = value.dictionaryValue {
                            
                            let messageDB = Database.database().reference()
                            
                            let newUser = User()
                            
                            newUser.userName = data["name"] as! String
                            newUser.userPassword = ""
                            newUser.userEmail = data["email"] as! String
                            
                            messageDB.observe(.value, with: { (snapshot) in
                                
                                let serverData = snapshot.value as! [String : String]
                                
                                newUser.userGreeting = serverData["Text"]!
                                
                                RealmManager.realmManager.saveObject(object: newUser, completion: { (success, savingError) in
                                    
                                    completion(success, error)
                                })
                            })
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Log out
    
    func signOut(completion: @escaping (Bool, Error?) -> Void) {
        
        do {
            
            try Auth.auth().signOut()
            
            completion(true, nil)
        }catch {
            
            completion(false, error)
        }
    }
    
    // MARK: - Helpers
    
    func helperForLogin(email:String, password: String,  completion: @escaping (Bool, Error?) -> Void) {
        
        let messageDB = Database.database().reference()
        let newUser = User()
        
        newUser.userPassword = password
        newUser.userEmail = email
        
        messageDB.observe(.value, with: { (snapshot) in
            
            let serverData = snapshot.value as! [String : String]
            
            newUser.userGreeting = serverData["Text"]!
            
            RealmManager.realmManager.saveObject(object: newUser, completion: { (success, savingError) in
                
                completion(success, savingError)
            })
        })
    }
}

