//
//  ExampleServiceTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest
@testable import VIPER

final class ExampleServiceTests: XCTestCase {

    var sut: ExampleService!

    override func setUp() {
        sut = ExampleService()
    }

    func testFetchItemsReturnsItems() {
        let expectation = XCTestExpectation(description: "fetchItems")
        sut.fetchItems { items in
            XCTAssertFalse(items.isEmpty)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
