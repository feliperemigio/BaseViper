//
//  LoginInteractorMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
@testable import VIPER

final class LoginInteractorMock: LoginInteractorProtocol {
    var loginReached = false
    var lastEmail: String?
    var lastPassword: String?

    func login(email: String, password: String) {
        self.loginReached = true
        self.lastEmail = email
        self.lastPassword = password
    }
}
