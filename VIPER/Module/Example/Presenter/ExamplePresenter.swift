//
//  ExamplePresenter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import Foundation

protocol ExamplePresenterProtocol: BasePresenterProtocol {
    func selectedItem(_ text: String)
}

final class ExamplePresenter: BasePresenter<ExamplePresenterDelegate, ExampleRouterProtocol, ExampleInteractorProtocol> {
    
    override func setUp() {
        self.interactor?.fetchTest()
    }
}

protocol ExamplePresenterDelegate: BasePresenterDelegate, ViewLoadable {
    
}

extension ExamplePresenter: ExamplePresenterProtocol {
    func selectedItem(_ text: String) {
        self.router?.presentTest()
    }
}

extension ExamplePresenter: ExampleInteractorDelegate {
    func fetchTestStarted() {
        self.delegate?.showLoading()
    }
    
    func didFetchTest() {
        self.delegate?.hideLoading()
    }
}
