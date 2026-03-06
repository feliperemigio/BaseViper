//
//  MockBase.swift
//  VIPERTests
//
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import Foundation

/// A base class for test mocks that automatically records every method call.
///
/// Subclass `MockBase` and call `record(#function)` at the start of each mock
/// method to get call tracking for free:
///
/// ```swift
/// final class MyMock: MyProtocol, MockBase {
///     func doSomething() {
///         record(#function)
///     }
/// }
/// let mock = MyMock()
/// mock.doSomething()
/// mock.wasCalled("doSomething()") // true
/// ```
class MockBase {
    private(set) var calledMethods: [String] = []

    /// Records that `method` was called. Pass `#function` for automatic naming.
    func record(_ method: String) {
        calledMethods.append(method)
    }

    /// Returns `true` if `method` was called at least once.
    func wasCalled(_ method: String) -> Bool {
        calledMethods.contains(method)
    }

    /// Returns the number of times `method` was called.
    func callCount(for method: String) -> Int {
        calledMethods.filter { $0 == method }.count
    }

    /// Resets all recorded calls.
    func resetCalls() {
        calledMethods.removeAll()
    }
}
