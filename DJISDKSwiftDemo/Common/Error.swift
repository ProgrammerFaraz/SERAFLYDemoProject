//
//  Error.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

enum APIError: Error {
    case serverCustomError(errorMessage: String)
    case internalServerError
    case parsingError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serverCustomError(let errorMessage):
            return NSLocalizedString(errorMessage, comment: errorMessage)
        case .internalServerError:
            return NSLocalizedString(Constants.errorMessage, comment: Constants.errorMessage)
        case .parsingError:
            return NSLocalizedString(Constants.errorMessage, comment: Constants.errorMessage)
        }
    }
}
