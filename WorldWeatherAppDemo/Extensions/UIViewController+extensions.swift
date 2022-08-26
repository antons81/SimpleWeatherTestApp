//
//  UIViewController+Extension.swift
//  DarioHealthDeemo
//
//  Created by Konstantin Khmara on 23.03.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func instantiateFromNib<T: UIViewController>() -> T {
        // It is going to return YourAppName.YourClassName
        let classDescription = classForCoder().description()
        // Replacing YourAppName with Empty string
        let nibFileName = classDescription.replacingOccurrences(of: "\(Bundle.main.infoDictionary?["CFBundleName"] as! String).", with: String())
        return T.init(nibName: nibFileName, bundle: Bundle.init(for: Self.self))
    }
}
