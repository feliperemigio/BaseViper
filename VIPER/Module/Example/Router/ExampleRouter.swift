//
//  ExampleRouter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

protocol ExampleRouterProtocol: BaseRouterProtocol {
    func presentTest()
}

final class ExampleRouter: BaseRouter<ExampleViewController> {
    class func createModule() -> ExampleViewController {
        let view = ExampleViewController()
        let presenter = ExamplePresenter(delegate: view, router: ExampleRouter(view: view))
        let interactor = ExampleInteractor(delegate: presenter)
        presenter.setUp(interactor: interactor)
        view.setUp(presenter: presenter)
        return view
    }
}

extension ExampleRouter: ExampleRouterProtocol {
    func presentTest() {
        let alertController = UIAlertController(title: "Present Test",
                                                message: "Detail",
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK",
                                        style: .cancel,
                                        handler: nil))
        self.view?.present(alertController, animated: true, completion: nil)
    }
}
