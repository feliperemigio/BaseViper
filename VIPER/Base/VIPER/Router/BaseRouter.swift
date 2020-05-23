//
//  BaseRouter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

protocol BaseRouterProtocol: AnyObject {
    
}

class BaseRouter<T: BaseViewControllerProtocol>: BaseRouterProtocol {
    let view : T?
    
    init(view: T) {
        self.view = view
    }
    
    var navigationController: UINavigationController? {
        if let navigationController = (self.view as? UIViewController)?.navigationController {
            return navigationController
        }
        
        return nil
    }
}
