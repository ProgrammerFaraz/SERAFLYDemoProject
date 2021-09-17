//
//  HelperMethods.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/2/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
