//
//  Utilities.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 9/5/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import SideMenu
import SCLAlertView

class Utilities {
    
    class func setupSideMenu(fromMap: Bool, viewController: UIViewController) {
        let sidemenuVC = SideMenuViewController.initFromStoryboard(name: Storyboards.Home)
        sidemenuVC.fromMap = fromMap
        let menu = SideMenuNavigationController(rootViewController: sidemenuVC)
        menu.setNavigationBarHidden(true, animated: false)
        menu.leftSide = true
        menu.menuWidth = UIScreen.main.bounds.width * 0.75
        viewController.present(menu, animated: true, completion: nil)

    }
    
    class func formatDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"

        let date = dateFormatter.date(from: dateString)
        return date
    }
}
