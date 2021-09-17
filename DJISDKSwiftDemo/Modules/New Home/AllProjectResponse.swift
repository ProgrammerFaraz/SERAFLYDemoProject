//
//  AllProjectResponse.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/6/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

struct AllProjectResponse : Codable {
    let status : String?
    let data : [AllProjectData]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
    }
}

struct AllProjectData : Codable {
    let id : Int?
    let name : String?
    let created_at : String?
    let distance : String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case created_at = "created_at"
        case distance = "distance"
    }
}
