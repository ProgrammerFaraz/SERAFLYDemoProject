//
//  SignupModel.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

struct SignupResponse : Codable {
    let status : String?
    let data : SignupData?
    let message : [String]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }
}

struct SignupData : Codable {
    let name : String?
    let email : String?
    let updated_at : String?
    let created_at : String?
    let id : Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case updated_at = "updated_at"
        case created_at = "created_at"
        case id = "id"
    }
}
