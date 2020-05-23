//
//  BaseInteractor.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

protocol BaseInteractorProtocol: AnyObject {
}

class BaseInteractor<T>: BaseInteractorProtocol {
    
    private weak var baseDelegate: BaseInteractorDelegate?
    
    var delegate: T? {
        return self.baseDelegate as? T
    }
    
    init(delegate: BaseInteractorDelegate?) {
        self.baseDelegate = delegate
    }
}

protocol BaseInteractorDelegate: AnyObject {
    
}
