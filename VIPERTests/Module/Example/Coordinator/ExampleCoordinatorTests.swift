//
//  ExampleCoordinatorTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest
@testable import VIPER

final class ExampleCoordinatorTests: XCTestCase {

    var sut: ExampleCoordinator!

    override func setUp() {
        sut = ExampleCoordinator()
    }

    func testMakeRootViewReturnsExampleView() {
        let view = sut.makeRootView()
        XCTAssertNotNil(view)
    }
}
