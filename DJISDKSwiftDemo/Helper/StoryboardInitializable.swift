//
//  StoryboardInitializable.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/21/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardInitializable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: Self.self)
    }
    
    static func initFromStoryboard(name: String) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        if let controller = storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as? Self {
            return controller
        }
        fatalError("Controller didn't initialized")
    }
}
