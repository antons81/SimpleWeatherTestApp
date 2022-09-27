//
//  ghhghghfghfgRouter.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ghhghghfghfgRouterProtocol: AnyObject {
    var view: ghhghghfghfgViewController? { get set }
    func openNextScreen()
}

class ghhghghfghfgRouter {
    // MARK: - Public variables
    internal weak var view: ghhghghfghfgViewController?
    
    // MARK: - Initialization
    init(view: ghhghghfghfgViewController) {
        self.view = view
    }

}

extension ghhghghfghfgRouter: ghhghghfghfgRouterProtocol {
    func openNextScreen() {
    }

}
