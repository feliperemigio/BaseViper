//
//  LoadablePresenter.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

/// Conforming presenter delegates can show and hide loading state.
///
/// Use this alongside `ViewLoadable` to give presenters a typed handle to
/// control loading indicators without importing UIKit.
protocol LoadablePresenterDelegate: BasePresenterDelegate, ViewLoadable {}

/// A presenter mixin that exposes `showLoading()` / `hideLoading()` helpers,
/// forwarding them to the delegate that conforms to `LoadablePresenterDelegate`.
///
/// Extend your presenter to conform to this protocol and call the helpers
/// instead of casting the delegate manually in every presenter subclass.
protocol LoadablePresenter: AnyObject {
    associatedtype LoadableDelegate: LoadablePresenterDelegate
    var loadableDelegate: LoadableDelegate? { get }
}

extension LoadablePresenter {
    /// Tells the view to display a loading indicator.
    func showLoading() {
        loadableDelegate?.showLoading()
    }

    /// Tells the view to hide the loading indicator.
    func hideLoading() {
        loadableDelegate?.hideLoading()
    }
}
