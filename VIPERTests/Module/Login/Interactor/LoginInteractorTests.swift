//
//  LoginInteractorTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
import Testing
@testable import VIPER

@Suite("LoginInteractor Tests")
struct LoginInteractorTests {

    var sut: LoginInteractor
    var delegate: LoginInteractorDelegateMock

    init() {
        self.delegate = LoginInteractorDelegateMock()
        self.sut = LoginInteractor(delegate: self.delegate)
    }

    @Test("login with valid credentials calls didLoginSuccess")
    func testLoginSuccess() async {
        await confirmation("didLoginSuccess called") { confirm in
            delegate.didLoginSuccessCompletion = { confirm() }
            sut.login(email: "user@example.com", password: "password123")
        }
        #expect(delegate.didLoginSuccessReached == true)
    }

    @Test("login with invalid credentials calls didLoginFailed")
    func testLoginFailure() async {
        await confirmation("didLoginFailed called") { confirm in
            delegate.didLoginFailedCompletion = { confirm() }
            sut.login(email: "wrong@test.com", password: "wrongpass")
        }
        #expect(delegate.didLoginFailedReached == true)
        #expect(delegate.loginFailedError == "Invalid email or password.")
    }

    @Test("login calls loginStarted immediately")
    func testLoginStarted() {
        sut.login(email: "user@example.com", password: "password123")
        #expect(delegate.loginStartedReached == true)
    }
}
