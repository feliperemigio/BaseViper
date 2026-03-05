//
//  LoginPresenter.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import Foundation

protocol LoginPresenterProtocol: BasePresenterProtocol {
    func doLogin(email: String, password: String)
}

final class LoginPresenter: BasePresenter<LoginPresenterDelegate, LoginRouterProtocol, LoginInteractorProtocol> {
    // no setUp override needed since login is triggered by user action
}

protocol LoginPresenterDelegate: BasePresenterDelegate, ViewLoadable {
    func loginSuccess()
    func loginFailed(error: String)
}

extension LoginPresenter: LoginPresenterProtocol {
    func doLogin(email: String, password: String) {
        self.interactor?.login(email: email, password: password)
    }
}

extension LoginPresenter: LoginInteractorDelegate {
    func loginStarted() {
        self.delegate?.showLoading()
    }

    func didLoginSuccess() {
        self.delegate?.hideLoading()
        self.delegate?.loginSuccess()
    }

    func didLoginFailed(error: String) {
        self.delegate?.hideLoading()
        self.delegate?.loginFailed(error: error)
    }
}
