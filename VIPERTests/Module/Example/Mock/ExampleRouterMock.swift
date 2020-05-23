//
//  ExampleRouterMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExampleRouterMock: ExampleRouterProtocol {
    var presentTestReached = false
    
    func presentTest() {
        self.presentTestReached = true
    }
}
