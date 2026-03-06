//
//  ExampleViewModelTests.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest
@testable import VIPER

final class ExampleViewModelTests: XCTestCase {

    var sut: ExampleViewModel!
    var service: ExampleServiceMock!

    override func setUp() {
        service = ExampleServiceMock()
        sut = ExampleViewModel(service: service)
    }

    func testLoadItemsCallsService() {
        sut.loadItems()
        XCTAssertTrue(service.fetchItemsReached)
    }

    func testLoadItemsPopulatesItems() {
        let expected = [ExampleItem(title: "Test")]
        service.stubbedItems = expected
        sut.loadItems()
        XCTAssertEqual(sut.items, expected)
    }

    func testOnAppearCallsLoadItems() {
        sut.onAppear()
        XCTAssertTrue(service.fetchItemsReached)
    }

    func testSelectItemCallsCoordinator() {
        let coordinator = ExampleCoordinatorMock()
        sut.coordinator = coordinator
        let item = ExampleItem(title: "Item")
        sut.selectItem(item)
        XCTAssertEqual(coordinator.navigatedItem, item)
    }
}
