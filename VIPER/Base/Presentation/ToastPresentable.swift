//
//  ToastPresentable.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

/// Provides a lightweight, non-intrusive toast notification that auto-dismisses.
///
/// Adopt this protocol on a `BasePresenterDelegate` to allow presenters to surface
/// transient messages without modal interruptions.
protocol ToastPresentable: AnyObject {
    func showToast(message: String, duration: TimeInterval)
}

extension ToastPresentable where Self: UIViewController {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        let horizontalPadding: CGFloat = 40
        let bottomOffset: CGFloat = 100
        let innerPadding: CGFloat = 20
        let verticalInset: CGFloat = 16

        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textAlignment = .center
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true

        let maxWidth = view.frame.width - horizontalPadding
        let size = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        toastLabel.frame = CGRect(
            x: (view.frame.width - size.width - innerPadding) / 2,
            y: view.frame.height - bottomOffset,
            width: size.width + innerPadding,
            height: size.height + verticalInset
        )

        view.addSubview(toastLabel)
        UIView.animate(withDuration: 0.3,
                       delay: duration,
                       options: .curveEaseOut,
                       animations: { toastLabel.alpha = 0 },
                       completion: { _ in toastLabel.removeFromSuperview() })
    }
}
