//
//  LoginPresenterDelegateMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
@testable import VIPER

final class LoginPresenterDelegateMock: LoginPresenterDelegate {
    var showLoadingReached = false
    var hideLoadingReached = false
    var loginSuccessReached = false
    var loginFailedReached = false
    var loginFailedError: String?

    func showLoading() {
        self.showLoadingReached = true
    }

    func hideLoading() {
        self.hideLoadingReached = true
    }

    func loginSuccess() {
        self.loginSuccessReached = true
    }

    func loginFailed(error: String) {
        self.loginFailedReached = true
        self.loginFailedError = error
    }
}
