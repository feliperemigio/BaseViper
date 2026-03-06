//
//  LoginPresenterTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
import XCTest
@testable import VIPER

final class LoginPresenterTests: XCTestCase {

    var sut: LoginPresenter!
    var delegate: LoginPresenterDelegateMock!
    var interactor: LoginInteractorMock!
    var router: LoginRouterMock!

    override func setUp() {
        self.delegate = LoginPresenterDelegateMock()
        self.router = LoginRouterMock()
        self.interactor = LoginInteractorMock()
        self.sut = LoginPresenter(delegate: self.delegate, router: self.router)
        self.sut.setUp(interactor: self.interactor)
    }

    func testDoLoginCallsInteractorWithCorrectCredentials() {
        self.sut.doLogin(email: "test@test.com", password: "pass123")
        XCTAssertTrue(self.interactor.loginReached)
        XCTAssertEqual(self.interactor.lastEmail, "test@test.com")
        XCTAssertEqual(self.interactor.lastPassword, "pass123")
    }

    func testLoginStartedShowsLoading() {
        self.sut.loginStarted()
        XCTAssertTrue(self.delegate.showLoadingReached)
    }

    func testDidLoginSuccessHidesLoadingAndNotifiesDelegate() {
        self.sut.didLoginSuccess()
        XCTAssertTrue(self.delegate.hideLoadingReached)
        XCTAssertTrue(self.delegate.loginSuccessReached)
    }

    func testDidLoginFailedHidesLoadingAndNotifiesDelegateWithError() {
        self.sut.didLoginFailed(error: "Invalid credentials")
        XCTAssertTrue(self.delegate.hideLoadingReached)
        XCTAssertTrue(self.delegate.loginFailedReached)
        XCTAssertEqual(self.delegate.loginFailedError, "Invalid credentials")
    }
}
