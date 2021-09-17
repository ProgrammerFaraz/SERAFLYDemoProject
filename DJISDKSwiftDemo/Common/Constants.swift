//
//  Constants.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/22/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

var isProduction: Environment = .Dev

enum Environment {
    case Dev
    case Production
}

struct APIConstant {
    
    static func getBaseURL() -> String{
        switch isProduction {
        case .Production:
           return ""
        case .Dev:
            return "http://api-projects.tumbitech.com/api/"
        }
    }
    
}
class Constants {
    
    static let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    static let baseURL = APIConstant.getBaseURL()
    
    static let errorMessage = "Something went wrong, please try again later."
    static let noDataMessage = "No Data Found"
    static let morePointsMessage = "Add more pin points"
}
struct CollectionViewCellIdentifiers {
    static let quickAccessCell = "QuickAccessCollectionViewCell"
}

struct TableViewCellIdentifiers {
    static let projectsCell = "ProjectTableViewCell"
    static let sidemenuCell = "SideMenuTableViewCell"
}

struct Storyboards {
    static let Main = "Main"
    static let Home = "Home"
    static let Authentication = "Authentication"
}
