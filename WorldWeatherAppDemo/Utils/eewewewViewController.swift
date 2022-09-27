//
//  eewewewViewController.swift
//  WorldWeatherAppDemo
//
//  Created by Anton Stremovskiy on 21.09.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol eewewewViewProtocol: AnyObject {
}

class eewewewViewController: UIViewController {
    // MARK: - Public properties
    var presenter: eewewewPresenterProtocol?
    var configurator: eewewewConfiguratorProtocol?
    
    // MARK: - Private properties
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator?.config(viewController: self)
        presenter?.viewDidLoad()
    }
    
    // MARK: - Display logic
    
    // MARK: - Actions
    
    // MARK: - Overrides
    
    // MARK: - Private functions
}

extension eewewewViewController: eewewewViewProtocol {
}
