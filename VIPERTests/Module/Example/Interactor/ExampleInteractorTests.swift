//
//  ExampleInteractorTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest
@testable import VIPER

final class ExampleInteractorTests: XCTestCase {
    
    var sut: ExampleInteractor!
    var delegate: ExampleInteractorDelegateMock!

    override func setUp() {
        self.delegate = ExampleInteractorDelegateMock()
        self.sut = ExampleInteractor(delegate: self.delegate)
    }

    func testExample() {
        self.sut.fetchTest()
        
        let expectation = XCTestExpectation()
        self.delegate.didFetchTestCompletion = {
            XCTAssertTrue(self.delegate.didFetchTestReached)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 6)
    }
}
