//
//  LoginModel.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    let status : String?
    let data : LoginData?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct LoginData : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let created_at : String?
    let updated_at : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case email = "email"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
}


