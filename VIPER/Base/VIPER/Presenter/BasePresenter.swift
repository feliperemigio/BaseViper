//
//  BasePresenter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

protocol BasePresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func setUp(interactor: BaseInteractorProtocol)
    func setUp()
}

class BasePresenter<T, V, Z>: BasePresenterProtocol {
    private weak var baseDelegate: BasePresenterDelegate?
    private var baseRouter: BaseRouterProtocol?
    private var baseInteractor: BaseInteractorProtocol?
    
    var delegate: T? { return self.baseDelegate as? T }
    var router: V? { return self.baseRouter as? V }
    var interactor: Z? {  return self.baseInteractor as? Z }
    
    init(delegate: BasePresenterDelegate?, router: BaseRouterProtocol?) {
        self.baseDelegate = delegate
        self.baseRouter = router
    }
    
    func setUp(interactor: BaseInteractorProtocol) {
        self.baseInteractor = interactor
    }
    
    func viewDidLoad() {
        self.setUp()
    }
    
    func viewWillAppear() {}
    func setUp() {}
}

protocol BasePresenterDelegate: AnyObject {
    
}

