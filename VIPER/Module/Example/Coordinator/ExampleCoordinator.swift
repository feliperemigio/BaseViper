//
//  ExampleCoordinator.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import SwiftUI

final class ExampleCoordinator: NSObject, Coordinator {
    func start() {}

    @discardableResult
    func makeRootView() -> ExampleView {
        let viewModel = ExampleViewModel(service: ExampleService())
        viewModel.coordinator = self
        return ExampleView(viewModel: viewModel)
    }

    func navigateToDetail(_ item: ExampleItem) {
        // Handle detail navigation
    }
}
