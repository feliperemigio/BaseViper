//
//  ExamplePresenterTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest
@testable import VIPER

final class ExamplePresenterTests: XCTestCase {
    
    var sut: ExamplePresenter!
    var delegate: ExamplePresenterDelegateMock!
    var interactor: ExampleInteractorMock!
    var router: ExampleRouterMock!

    override func setUp() {
        self.delegate = ExamplePresenterDelegateMock()
        self.router = ExampleRouterMock()
        self.interactor = ExampleInteractorMock()
        self.sut = ExamplePresenter(delegate: self.delegate, router: self.router)
        self.sut.setUp(interactor: self.interactor)
    }

    func testExampleSetUp() {
        self.sut.setUp()
        XCTAssertTrue(self.interactor.fetchTestReached)
    }
    
    func testExampleDidFetchTest() {
        self.sut.didFetchTest()
        
        XCTAssertTrue(self.delegate.hideLoadingReached)
    }
    
    func testExampleFetchTestStarted() {
        self.sut.fetchTestStarted()
        
        XCTAssertTrue(self.delegate.showLoadingReached)
    }

}
