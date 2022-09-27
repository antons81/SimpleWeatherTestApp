//
//  eewewewPresenter.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol eewewewPresenterProtocol: AnyObject {
    var view: eewewewViewProtocol? { get set }
    func viewDidLoad()
}

class eewewewPresenter {
    // MARK: - Public variables
    internal weak var view: eewewewViewProtocol?

    // MARK: - Private variables
    private let router: eewewewRouterProtocol
    private let service: eewewewServiceProtocol
    
    // MARK: - Initialization
    init(router: eewewewRouterProtocol,
         view: eewewewViewProtocol,
         service: eewewewServiceProtocol) {
        
        self.service = service
        self.router = router
        self.view = view
    }

}

extension eewewewPresenter: eewewewPresenterProtocol {
    func viewDidLoad() {
    }
    
}
