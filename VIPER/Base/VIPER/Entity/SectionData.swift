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
    let footerTitle: String?
    var items: [T]

    init(id: Int? = nil,
         headerTitle: String? = nil,
         footerTitle: String? = nil,
         items: [T] = []) {
        self.id = id
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.items = items
    }

    mutating func append(item: T) {
        self.items.append(item)
    }

    mutating func append(contentsOf newItems: [T]) {
        self.items.append(contentsOf: newItems)
    }

    mutating func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
    }

    var count: Int {
        return items.count
    }

    var isEmpty: Bool {
        return items.isEmpty
    }

    subscript(index: Int) -> T? {
        return items[safe: index]
    }
}

extension SectionData: Equatable where T: Equatable {}

extension SectionData: Codable where T: Codable {}

// MARK: - Array Utility Extension

extension Array {
    /// Returns the element at the given index, or nil if the index is out of bounds.
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
