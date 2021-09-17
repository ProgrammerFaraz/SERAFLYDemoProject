//
//  ForgotPasswordModel.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/2/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

struct ForgotPasswordModel : Codable {
    let status : String?
    let message : String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
    }
}
