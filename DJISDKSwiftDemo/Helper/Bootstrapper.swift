//
//  Bootstrapper.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/28/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import UIKit
import SideMenu

struct Bootstrapper {
    
    // MARK: - VARIBALES
    var window: UIWindow
    //let pushServices = NotificationsService.shared
    static var instance: Bootstrapper? = nil
    
    // MARK: - INITIALIZE
    
    static func initialize() {
        instance = Bootstrapper(window: makeNewWindow())
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            Bootstrapper.setupTheLanguage()
        //        }
        instance!.bootstrap()
        //        Thread.sleep(forTimeInterval: 1)
    }
    
    // MARK: - RESET
    static func reset() {
        //        instance!.resetValues()
        let win = instance!.window
        instance!.window = makeNewWindow()
        instance!.bootstrap()
        win.rootViewController = nil
        win.removeFromSuperview()
    }
    
    
    static func showPreviousFlow(){
        instance!.showPreviousFlow()
    }
    
    static func showSideMenu(){
        instance!.showSideMenu()
    }
//
    static func showLogin() {
        instance!.showLogin()
    }
    
//    static func showNotification(){
//        instance!.showNotification()
//    }
//
    static func showHome() {
        instance!.showHome()
    }
    
    private static func makeNewWindow() -> UIWindow {
        if let del = UIApplication.shared.delegate as? AppDelegate {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = UIColor.white
            del.window = window
            return del.window!
        }
        return UIWindow()
    }
    
    mutating func bootstrap() {
        
        if UserDefaultsHelper.shared.getName().isEmpty{
            self.showLogin()
        }else{
//            self.showPreviousFlow()
            self.showHome()
        }
        
        window.makeKeyAndVisible()
    }
    
    
    private func showLogin(){
        let navigationController = RootNavigationViewController.initFromStoryboard(name: Storyboards.Authentication)
        let appliction = UIApplication.shared.delegate as? AppDelegate
        appliction?.window!.rootViewController = navigationController
        appliction?.window!.makeKeyAndVisible()
    }
   
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    private func showPreviousFlow(){
        let controller = StartupViewController.initFromStoryboard(name: Storyboards.Main)
        self.window.rootViewController = controller

    }

    private func showHome() {
        let rootNavVC = RootNavigationViewController.initFromStoryboard(name: Storyboards.Authentication)
        rootNavVC.userLoggedIn = true
        let appliction = UIApplication.shared.delegate as? AppDelegate
        appliction?.window!.rootViewController = rootNavVC
        appliction?.window!.makeKeyAndVisible()
    }
    
    private func showSideMenu() {

        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
//        self.present(menu, animated: true, completion: nil)

    }
}
