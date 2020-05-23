//
//  RoomServiceSectionData.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import Foundation
struct SectionData<T> {
    let id: Int?
    let headerTitle: String?
    var items: [T]
    
    mutating func append(item: T) {
        self.items.append(item)
    }
}
