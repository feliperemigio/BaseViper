//
//  AsyncTestHelpers.swift
//  VIPERTests
//
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest

extension XCTestCase {
    /// Waits for `condition` to become `true`, failing after `timeout` seconds.
    ///
    /// Unlike `XCTAssertEventually`, this method integrates with `XCTestExpectation`
    /// for proper run-loop integration.
    ///
    /// - Parameters:
    ///   - condition: A closure that returns `true` when the expected state is reached.
    ///   - timeout: Maximum time to wait. Defaults to 5 seconds.
    ///   - description: Human-readable description shown on timeout.
    func waitForCondition(
        _ condition: @escaping () -> Bool,
        timeout: TimeInterval = 5.0,
        description: String = "Async condition",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectation = expectation(description: description)
        let interval: TimeInterval = 0.05
        var elapsed: TimeInterval = 0

        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            elapsed += interval
            if condition() {
                timer.invalidate()
                expectation.fulfill()
            } else if elapsed >= timeout {
                timer.invalidate()
                // Do not fulfill — let wait(for:timeout:) handle the failure path.
            }
        }
        RunLoop.current.add(timer, forMode: .common)

        wait(for: [expectation], timeout: timeout + 1)
    }

    /// Creates a fulfilled `XCTestExpectation` with a completion handler stored on the mock delegate.
    ///
    /// Example:
    /// ```swift
    /// let exp = expectCompletion(on: &mock.didFinishCompletion)
    /// sut.doWork()
    /// wait(for: [exp], timeout: 5)
    /// ```
    func expectCompletion(
        on handler: inout (() -> Void)?,
        description: String = "completion handler called",
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> XCTestExpectation {
        let exp = expectation(description: description)
        handler = { exp.fulfill() }
        return exp
    }
}
