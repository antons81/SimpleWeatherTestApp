//
//  UIStackView+extensions.swift
//  DarioHealthDeemo
//
//  Created by Anton Stremovskiy on 21.09.2020.
//  Copyright © 2020 Shooting App. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    @discardableResult
    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}
