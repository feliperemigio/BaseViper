//
//  PropertyTracker.swift
//  VIPERTests
//
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import Foundation

/// Tracks assignments to a property and records its change history.
///
/// Wrap any property in your mock with `PropertyTracker` to observe every value
/// it receives during a test:
///
/// ```swift
/// final class MyViewMock {
///     let titleTracker = PropertyTracker<String>()
///     var title: String? {
///         get { titleTracker.value }
///         set { titleTracker.set(newValue) }
///     }
/// }
/// mock.title = "Hello"
/// mock.title = "World"
/// mock.titleTracker.history // ["Hello", "World"]
/// ```
final class PropertyTracker<T> {
    /// The most recently assigned value.
    private(set) var value: T?

    /// All values assigned since the last `reset()`, in order.
    private(set) var history: [T] = []

    /// The number of times a value has been assigned.
    var assignmentCount: Int { history.count }

    /// `true` if at least one value has been assigned.
    var wasSet: Bool { !history.isEmpty }

    /// Records `newValue` and updates `value`.
    func set(_ newValue: T?) {
        value = newValue
        if let newValue {
            history.append(newValue)
        }
    }

    /// Clears `value` and `history`.
    func reset() {
        value = nil
        history.removeAll()
    }
}
