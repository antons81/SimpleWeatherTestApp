//
//  ghhghghfghfgPresenter.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ghhghghfghfgPresenterProtocol: AnyObject {
    var view: ghhghghfghfgViewProtocol? { get set }
    func viewDidLoad()
}

class ghhghghfghfgPresenter {
    // MARK: - Public variables
    internal weak var view: ghhghghfghfgViewProtocol?

    // MARK: - Private variables
    private let router: ghhghghfghfgRouterProtocol
    private let service: ghhghghfghfgServiceProtocol
    
    // MARK: - Initialization
    init(router: ghhghghfghfgRouterProtocol,
         view: ghhghghfghfgViewProtocol,
         service: ghhghghfghfgServiceProtocol) {
        
        self.service = service
        self.router = router
        self.view = view
    }

}

extension ghhghghfghfgPresenter: ghhghghfghfgPresenterProtocol {
    func viewDidLoad() {
    }
    
}
