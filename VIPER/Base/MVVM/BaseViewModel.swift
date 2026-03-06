//
//  BaseViewModel.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()

    func onAppear() {}
    func onDisappear() {}
}
