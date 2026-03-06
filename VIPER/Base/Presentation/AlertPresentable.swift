//
//  AlertPresentable.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

/// Provides a standard way to show alerts from any `UIViewController` subclass.
///
/// Adopt this protocol on a `BasePresenterDelegate` to allow presenters to trigger
/// alert dialogs without coupling them to `UIAlertController` directly.
protocol AlertPresentable: AnyObject {
    func showAlert(title: String, message: String, actions: [UIAlertAction])
}

extension AlertPresentable where Self: UIViewController {
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alert.addAction($0) }
        }
        present(alert, animated: true)
    }
}
