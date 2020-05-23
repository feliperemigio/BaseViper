//
//  ExampleInteractor.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//
import Foundation

protocol ExampleInteractorProtocol: BaseInteractorProtocol {
    func fetchTest()
}

final class ExampleInteractor: BaseInteractor<ExampleInteractorDelegate> {
    
}

protocol ExampleInteractorDelegate: BaseInteractorDelegate {
    func fetchTestStarted()
    func didFetchTest()
}

extension ExampleInteractor: ExampleInteractorProtocol {
    func fetchTest() {
        self.delegate?.fetchTestStarted()
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            OperationQueue.main.addOperation {
                self.delegate?.didFetchTest()
            }
        }
    }
}
