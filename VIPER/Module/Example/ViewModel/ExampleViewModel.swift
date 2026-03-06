//
//  ExampleViewModel.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import Foundation

final class ExampleViewModel: BaseViewModel {
    @Published var items: [ExampleItem] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil

    private let service: ExampleServiceProtocol
    weak var coordinator: ExampleCoordinator?

    init(service: ExampleServiceProtocol = ExampleService()) {
        self.service = service
    }

    override func onAppear() {
        loadItems()
    }

    func loadItems() {
        isLoading = true
        service.fetchItems { [weak self] fetchedItems in
            self?.isLoading = false
            self?.items = fetchedItems
        }
    }

    func selectItem(_ item: ExampleItem) {
        coordinator?.navigateToDetail(item)
    }
}
