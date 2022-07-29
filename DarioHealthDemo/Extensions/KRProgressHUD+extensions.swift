//
//  KRProgressHUD+extensions.swift
//  Kyivpride
//
//  Created by Anton Stremovskiy on 04.04.2021.
//

import Foundation
import KRProgressHUD

extension KRProgressHUD {
    
    public static func showSpinnerProgress() {
        KRProgressHUD.set(style: .custom(background: .white, text: .black, icon: nil))
        KRProgressHUD.set(activityIndicatorViewColors: [.black])
        KRProgressHUD.set(maskType: .clear)
        KRProgressHUD.set(font: .systemFont(ofSize: 16))
        KRProgressHUD.set(duration: 3)
        KRProgressHUD.show(withMessage: "Syncing with server...")
    }
    
    public static func showProgress() {
        KRProgressHUD.set(style: .custom(background: .white, text: .black, icon: .none))
        KRProgressHUD.set(activityIndicatorViewColors: [.black])
        KRProgressHUD.set(maskType: .clear)
        KRProgressHUD.set(font: .systemFont(ofSize: 16))
        KRProgressHUD.show()
    }
    
    static func dismissProgress(_ completion: SimpleCompletion) {
        KRProgressHUD.dismiss {
            completion?()
        }
    }
}
