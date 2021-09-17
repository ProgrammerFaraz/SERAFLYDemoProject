//
//  HomeAPIService.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/6/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import Alamofire

class HomeAPIService {
    
    public static let shared = HomeAPIService()

    private init() {
    }
    
    func getAllProjects(userID: String, completion: @escaping (AFResult<AllProjectResponse>) -> Void) {
        Networking.shared.performRequest(route: Constants.baseURL + "projects?user_id=\(userID)", method: .get, parameters: nil, encoding: JSONEncoding.default, completion: completion)
    }

}
