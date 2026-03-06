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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.basePresenter?.viewDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.basePresenter?.viewDidDisappear()
    }

    func setUp(presenter: BasePresenterProtocol) {
        self.basePresenter = presenter
    }
}
