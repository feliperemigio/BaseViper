//
//  LoginInteractorTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//
import XCTest
@testable import VIPER

final class LoginInteractorTests: XCTestCase {

    var sut: LoginInteractor!
    var delegate: LoginInteractorDelegateMock!

    override func setUp() {
        self.delegate = LoginInteractorDelegateMock()
        self.sut = LoginInteractor(delegate: self.delegate)
    }

    func testLoginCallsLoginStartedImmediately() {
        self.sut.login(email: "test@test.com", password: "pass123")
        XCTAssertTrue(self.delegate.loginStartedReached)
    }
}
