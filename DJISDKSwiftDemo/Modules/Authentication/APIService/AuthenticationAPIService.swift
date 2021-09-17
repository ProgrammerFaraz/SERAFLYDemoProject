//
//  AuthenticationAPIService.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationAPIService {
    
    public static let shared = AuthenticationAPIService()

    private init() {
    }
    
    func loginUser(params: [String: Any], completion: @escaping (AFResult<LoginResponse>) -> Void) {
        Networking.shared.performRequest(route: Constants.baseURL + "login", method: .post, parameters: params, encoding: JSONEncoding.default, completion: completion)
    }
    
    func signupUser(params: [String: Any], completion: @escaping (AFResult<SignupResponse>) -> Void) {
        Networking.shared.performRequest(route: Constants.baseURL + "register", method: .post, parameters: params, encoding: JSONEncoding.default, completion: completion)
    }
    
    func resetPassword(params: [String: Any], completion: @escaping (AFResult<ForgotPasswordModel>) -> Void) {
        Networking.shared.performRequest(route: Constants.baseURL + "reset-password", method: .post, parameters: params, encoding: JSONEncoding.default, completion: completion)
    }

}
