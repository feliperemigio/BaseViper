//
//  LoginRouter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import UIKit

protocol LoginRouterProtocol: BaseRouterProtocol {
}

final class LoginRouter: BaseRouter<LoginViewController> {
    class func createModule() -> LoginViewController {
        let view = LoginViewController()
        let presenter = LoginPresenter(delegate: view, router: LoginRouter(view: view))
        let interactor = LoginInteractor(delegate: presenter)
        presenter.setUp(interactor: interactor)
        view.setUp(presenter: presenter)
        return view
    }
}

extension LoginRouter: LoginRouterProtocol {
}
