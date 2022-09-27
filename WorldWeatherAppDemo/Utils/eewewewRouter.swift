//
//  eewewewRouter.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol eewewewRouterProtocol: AnyObject {
    var view: eewewewViewController? { get set }
    func openNextScreen()
}

class eewewewRouter {
    // MARK: - Public variables
    internal weak var view: eewewewViewController?
    
    // MARK: - Initialization
    init(view: eewewewViewController) {
        self.view = view
    }

}

extension eewewewRouter: eewewewRouterProtocol {
    func openNextScreen() {
    }

}
