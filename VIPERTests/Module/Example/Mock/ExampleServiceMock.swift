//
//  ExampleServiceMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExampleServiceMock: ExampleServiceProtocol {
    var fetchItemsReached = false
    var stubbedItems: [ExampleItem] = []

    func fetchItems(completion: @escaping ([ExampleItem]) -> Void) {
        fetchItemsReached = true
        completion(stubbedItems)
    }
}
