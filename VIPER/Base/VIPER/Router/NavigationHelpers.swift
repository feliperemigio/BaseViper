//
//  NavigationHelpers.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

/// Navigation helpers added to every `BaseRouter` subclass.
extension BaseRouter {

    // MARK: - Push

    /// Pushes `viewController` onto the navigation stack.
    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    /// Pops the top view controller from the navigation stack.
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// Pops to the root view controller.
    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    // MARK: - Modal

    /// Presents `viewController` modally from the router's associated view.
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        (view as? UIViewController)?.present(viewController, animated: animated, completion: completion)
    }

    /// Dismisses the currently presented modal view controller.
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        (view as? UIViewController)?.dismiss(animated: animated, completion: completion)
    }
}
