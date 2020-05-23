//
//  ViewLoadable.swift
//  VIPER
//
//  Created by Felipe Remigio on 22/05/20.
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

protocol ViewLoadable: AnyObject {
    func showLoading()
    func hideLoading()
}

extension ViewLoadable where Self : UIViewController {
    func showLoading() {
        let indicator = UIActivityIndicatorView()
        indicator.style = .medium
        self.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        indicator.startAnimating()
    }
    func hideLoading() {
        self.view.subviews.first(where: {$0 is UIActivityIndicatorView})?.removeFromSuperview()
    }
}
