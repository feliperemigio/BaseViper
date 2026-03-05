//
//  LoginPresenterTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
import Testing
@testable import VIPER

@Suite("LoginPresenter Tests")
struct LoginPresenterTests {

    var sut: LoginPresenter
    var delegate: LoginPresenterDelegateMock
    var interactor: LoginInteractorMock
    var router: LoginRouterMock

    init() {
        self.delegate = LoginPresenterDelegateMock()
        self.router = LoginRouterMock()
        self.interactor = LoginInteractorMock()
        self.sut = LoginPresenter(delegate: self.delegate, router: self.router)
        self.sut.setUp(interactor: self.interactor)
    }

    @Test("doLogin calls interactor login with correct credentials")
    func testDoLogin() {
        sut.doLogin(email: "test@test.com", password: "pass123")
        #expect(interactor.loginReached == true)
        #expect(interactor.lastEmail == "test@test.com")
        #expect(interactor.lastPassword == "pass123")
    }

    @Test("loginStarted shows loading")
    func testLoginStarted() {
        sut.loginStarted()
        #expect(delegate.showLoadingReached == true)
    }

    @Test("didLoginSuccess hides loading and notifies delegate")
    func testDidLoginSuccess() {
        sut.didLoginSuccess()
        #expect(delegate.hideLoadingReached == true)
        #expect(delegate.loginSuccessReached == true)
    }

    @Test("didLoginFailed hides loading and notifies delegate with error")
    func testDidLoginFailed() {
        sut.didLoginFailed(error: "Invalid credentials")
        #expect(delegate.hideLoadingReached == true)
        #expect(delegate.loginFailedReached == true)
        #expect(delegate.loginFailedError == "Invalid credentials")
    }
}
