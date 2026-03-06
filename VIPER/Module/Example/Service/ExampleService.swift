//
//  ExampleService.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import Foundation

protocol ExampleServiceProtocol: Service {
    func fetchItems(completion: @escaping ([ExampleItem]) -> Void)
}

final class ExampleService: ExampleServiceProtocol {
    func fetchItems(completion: @escaping ([ExampleItem]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let items = [
                ExampleItem(title: "Teste 1"),
                ExampleItem(title: "Teste 2"),
                ExampleItem(title: "Teste 3")
            ]
            OperationQueue.main.addOperation {
                completion(items)
            }
        }
    }
}
