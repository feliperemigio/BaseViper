//
//  ModuleFactory+DI.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

/// Convenience helpers for embedding a VIPER module inside a navigation controller
/// or presenting it modally, reducing repeated boilerplate in every Router.
extension UIViewController {
    /// Wraps `self` in a `UINavigationController` and returns it.
    func embeddedInNavigationController() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }
}

/// A lightweight dependency container that resolves a single shared instance per type.
///
/// Usage:
/// ```swift
/// ViperDependencyContainer.shared.register(type: NetworkService.self) { NetworkService() }
/// let service: NetworkService = ViperDependencyContainer.shared.resolve()
/// ```
final class ViperDependencyContainer {
    static let shared = ViperDependencyContainer()
    private var factories: [String: () -> Any] = [:]
    private var instances: [String: Any] = [:]

    private init() {}

    /// Registers a factory closure for `type`. The instance is created lazily on first `resolve`.
    func register<T>(type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }

    /// Returns the shared instance for `T`, creating it via the registered factory if needed.
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        if let existing = instances[key] as? T {
            return existing
        }
        guard let factory = factories[key], let instance = factory() as? T else {
            fatalError("ViperDependencyContainer: no factory registered for \(key). Did you forget to call register(type:factory:)?")
        }
        instances[key] = instance
        return instance
    }

    /// Removes all registered factories and cached instances (useful in tests).
    func reset() {
        factories.removeAll()
        instances.removeAll()
    }
}
