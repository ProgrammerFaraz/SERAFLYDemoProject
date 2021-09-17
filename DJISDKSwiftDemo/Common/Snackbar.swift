//
//  Snackbar.swift
//  DJISDKSwiftDemo
//
//  Created by Faraz on 8/31/21.
//  Copyright © 2021 DJI. All rights reserved.
//

import Foundation
import TTGSnackbar

struct Snackbar {
    
    static func show(message: String, duration: TTGSnackbarDuration = .middle) {
        let snackbar = TTGSnackbar(message: message, duration: duration)
        snackbar.show()
    }
}
