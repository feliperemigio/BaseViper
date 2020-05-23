//
//  ExampleInteractorDelegateMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExampleInteractorDelegateMock: ExampleInteractorDelegate {
    var didFetchTestReached = false
    var fetchTestStartedReached = false
    
    var didFetchTestCompletion: (() -> Void)?
    
    func didFetchTest() {
        self.didFetchTestReached = true
        self.didFetchTestCompletion?()
    }
    
    func fetchTestStarted() {
        self.fetchTestStartedReached = true
    }
}
