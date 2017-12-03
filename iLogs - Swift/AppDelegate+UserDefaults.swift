//
//  AppDelegate+UserDefaults.swift
//  iLogs - Swift
//
//  Created by Erick Sanchez on 12/2/17.
//  Copyright © 2017 Erick Sanchez. All rights reserved.
//

import Foundation

extension UserDefaults {
    class var tutorialHasPresentedTapStatusBarToDimiss: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "hasPresentedTapStatusBarToDimiss")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "hasPresentedTapStatusBarToDimiss")
        }
    }
}
