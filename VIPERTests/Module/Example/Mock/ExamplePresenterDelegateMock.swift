//
//  ExamplePresenterDelegateMock.swift
//  VIPERTests
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

@testable import VIPER

final class ExamplePresenterDelegateMock: ExamplePresenterDelegate {
    var showLoadingReached = false
    var hideLoadingReached = false
    
    func showLoading() {
        self.showLoadingReached = true
    }
    
    func hideLoading() {
        self.hideLoadingReached = true
    }
}
