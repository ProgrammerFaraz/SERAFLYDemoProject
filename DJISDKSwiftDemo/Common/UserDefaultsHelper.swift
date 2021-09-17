//
//  UserDefaultsHelper.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    
    private init() {}
    
    func setUserId(userID: Int) {
        UserDefaults.standard.set(userID, forKey: "id")
    }
    
    func getUserId() -> Int {
        var output = 0
        let status = UserDefaults.standard.integer(forKey: "id")
        output = status
        return output
    }
    
    func setName(name: String) {
        UserDefaults.standard.set(name, forKey: "name")
    }
    
    func getName () -> String {
        var output = ""
        if let firstName = UserDefaults.standard.string(forKey: "name") {
            output = firstName
        }
        return output
    }
    
    func setEmail(email: String) {
        UserDefaults.standard.set(email, forKey: "email")
    }
    
    func getEmail() -> String {
        var output = ""
        if let email = UserDefaults.standard.string(forKey: "email") {
            output = email
        }
        return output
    }
}
