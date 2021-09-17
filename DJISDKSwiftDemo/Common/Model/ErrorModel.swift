//
//  ErrorModel.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

struct ErrorModel: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "error_msg"
    }
}
