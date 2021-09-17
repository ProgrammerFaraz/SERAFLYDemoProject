//
//  Networking.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import Alamofire

class Networking {
    
    var headers: HTTPHeaders?
    
    public static let shared = Networking()
    
    private init() {
        headers = [HTTPHeader(name: "Content-Type", value: "application/json")]
    }
    
    @discardableResult
    func performRequest<T: Decodable>(route: String, method: HTTPMethod, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, decoder: JSONDecoder = JSONDecoder(), completion: @escaping (AFResult<T>) -> Void) -> DataRequest {
        if let params = parameters{
            return AF.request(route, method: method, parameters: params, encoding: encoding, headers: headers, interceptor: nil, requestModifier: nil).responseData { (response) in
                
                switch response.result {
                case .success(let data):
                    do {
                        let responseObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(responseObject))
                        return
                    } catch {
                        if let customError = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                            completion(.failure(AFError.sessionTaskFailed(error: (APIError.serverCustomError(errorMessage: customError.message)))))
                            return
                        }
                        completion(.failure(AFError.sessionTaskFailed(error: APIError.parsingError)))
                        return
                    }
                case .failure(_):
                    completion(.failure(AFError.sessionTaskFailed(error: APIError.internalServerError)))
                }
            }
        }else
        {
            return AF.request(route, method: method, parameters: nil, encoding: encoding, headers: headers, interceptor: nil, requestModifier: nil).responseData { (response) in
                
                switch response.result {
                case .success(let data):
                    do {
                        let responseObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(responseObject))
                        return
                    } catch {
                        if let customError = try? JSONDecoder().decode(ErrorModel.self, from: data) {
                            completion(.failure(AFError.sessionTaskFailed(error: APIError.serverCustomError(errorMessage: customError.message))))
                            return
                        }
                        completion(.failure(AFError.sessionTaskFailed(error: APIError.parsingError)))
                        return
                    }
                case .failure(_):
                    completion(.failure(AFError.sessionTaskFailed(error: APIError.internalServerError)))
                }
            }
        }
    }
    
    typealias CompletionHandler<T> = (AFResult<T>) -> Void
}
