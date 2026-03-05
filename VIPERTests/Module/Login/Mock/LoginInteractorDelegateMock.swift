//
//  LoginInteractorDelegateMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
@testable import VIPER

final class LoginInteractorDelegateMock: LoginInteractorDelegate {
    var loginStartedReached = false
    var didLoginSuccessReached = false
    var didLoginFailedReached = false
    var loginFailedError: String?

    var didLoginSuccessCompletion: (() -> Void)?
    var didLoginFailedCompletion: (() -> Void)?

    func loginStarted() {
        self.loginStartedReached = true
    }

    func didLoginSuccess() {
        self.didLoginSuccessReached = true
        self.didLoginSuccessCompletion?()
    }

    func didLoginFailed(error: String) {
        self.didLoginFailedReached = true
        self.loginFailedError = error
        self.didLoginFailedCompletion?()
    }
}
