//
//  RealmManager.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class RealmManager {
    
    private let realm = try! Realm()
    
    static let realmManager: RealmManager = RealmManager()
    
    private init() {}
    
    // MARK: - Save
    
    func saveObject(object: Object, completion: @escaping (Bool, Error?) -> Void)  {
        
        do {
            
            try realm.write {
                
                realm.add(object)
                
                completion(true, nil)
            }
        }catch {
            
            completion(false, error)
        }
    }
    
    // MARK: - Delete
    
    func delete()  {
        
        let currentUser = realm.objects(User.self).first
        
        try! realm.write {
            
            realm.delete(currentUser!)
        }
    }
    
    // MARK: - Get saved object
    
    func getObject() -> User? {
        
        let currentUser = realm.objects(User.self).first
        
        return currentUser
    }
    
    // MARK: - Update user data
    
    func updateObject(userMail: String, userName: String, userGender: String, userAge: String) {
        
        if let currentUser = realm.objects(User.self).first {
            
            try! realm.write {
                
                currentUser.userEmail = userMail
                currentUser.userName = userName
                currentUser.userGender = userGender
                currentUser.userAge = userAge
            }
        }
    }
    
}
