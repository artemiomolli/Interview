//
//  User.swift
//  Interfview
//
//  Created by Артём Гуральник on 11/24/18.
//  Copyright © 2018 Артём Гуральник. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var userPassword: String = ""
    @objc dynamic var userEmail: String = ""
    @objc dynamic var userName: String = ""
    @objc dynamic var userAge: String = ""
    @objc dynamic var userGender: String = ""
    @objc dynamic var userGreeting: String = ""
}
