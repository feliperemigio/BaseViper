//
//  ExampleInteractorMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExampleInteractorMock: ExampleInteractorProtocol {
    var fetchTestReached = false
    
    func fetchTest() {
        self.fetchTestReached = true
    }
    
}
