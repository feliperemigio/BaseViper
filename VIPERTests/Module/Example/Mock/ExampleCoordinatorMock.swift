//
//  ExampleCoordinatorMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExampleCoordinatorMock: ExampleCoordinator {
    var navigatedItem: ExampleItem?

    override func navigateToDetail(_ item: ExampleItem) {
        navigatedItem = item
    }
}
