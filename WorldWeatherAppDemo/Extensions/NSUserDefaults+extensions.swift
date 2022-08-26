//
//  NSUserDefaults+extensions.swift
//  
//
//  Created by Anton Stremovskiy on 20.06.2022.
//

import Foundation

extension UserDefaults {

    private enum Keys {
        static let isImperial = "isImperial"
    }

    class var isImperial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isImperial)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isImperial)
        }
    }
}
