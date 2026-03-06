//
//  XCTestAssertHelpers.swift
//  VIPERTests
//
//  Copyright © 2020 Felipe Remigio. All rights reserved.
//

import XCTest

/// Asserts that `expression` eventually becomes `true` within `timeout` seconds,
/// polling every `interval` seconds.
///
/// - Parameters:
///   - expression: An auto-closure evaluated repeatedly until it returns `true`.
///   - timeout: Maximum time to wait before failing. Defaults to 2 seconds.
///   - interval: How often to re-evaluate `expression`. Defaults to 0.05 seconds.
///   - message: Failure message. Defaults to a generic description.
func XCTAssertEventually(
    _ expression: @autoclosure () -> Bool,
    timeout: TimeInterval = 2.0,
    interval: TimeInterval = 0.05,
    _ message: @autoclosure () -> String = "Condition was not met in time",
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let deadline = Date(timeIntervalSinceNow: timeout)
    while Date() < deadline {
        if expression() { return }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: interval))
    }
    XCTFail(message(), file: file, line: line)
}

/// Asserts that `mock.wasCalled(_:)` returns `true` for each method name in `methods`.
func XCTAssertMethodsCalled(
    _ mock: MockBase,
    methods: String...,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    for method in methods {
        XCTAssertTrue(mock.wasCalled(method),
                      "Expected '\(method)' to be called but it was not.",
                      file: file,
                      line: line)
    }
}

/// Asserts that `mock` received exactly `count` calls for `method`.
func XCTAssertCallCount(
    _ mock: MockBase,
    method: String,
    count: Int,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let actual = mock.callCount(for: method)
    XCTAssertEqual(actual, count,
                   "Expected '\(method)' to be called \(count) time(s) but was called \(actual) time(s).",
                   file: file,
                   line: line)
}
