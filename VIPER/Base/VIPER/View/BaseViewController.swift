//
//  BaseViewController.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func setUp(presenter: BasePresenterProtocol)
}

class BaseViewController<T>: UIViewController, BaseViewControllerProtocol {
    
    private var basePresenter: BasePresenterProtocol?
    
    var presenter: T? {
        return self.basePresenter as? T
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.basePresenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.basePresenter?.viewWillAppear()
    }
    
    func setUp(presenter: BasePresenterProtocol) {
        self.basePresenter = presenter
    }
}
