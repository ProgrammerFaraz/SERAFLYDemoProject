//
//  RootNavigationViewController.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/28/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    var userLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userLoggedIn {
            self.navigationController?.setViewControllers([], animated: true)
            let vc = NewHomeViewController.initFromStoryboard(name: Storyboards.Home)
            self.pushViewController(vc, animated: true)
        }
    }
    
}

extension RootNavigationViewController: StoryboardInitializable {}
