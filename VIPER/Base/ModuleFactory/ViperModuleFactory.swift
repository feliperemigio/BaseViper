//
//  ViperModuleFactory.swift
//  VIPER
//
//  Copyright © 2020 Remigio All rights reserved.
//

import UIKit

/// Protocol that standardises VIPER module creation.
///
/// Conforming types only need to provide the four wired-up VIPER components;
/// the default `makeModule()` implementation handles connecting them together.
///
/// - Example:
/// ```swift
/// enum LoginFactory: ViperModuleFactory {
///     static func makeView() -> LoginViewController { LoginViewController() }
///     static func makePresenter(view: LoginViewController) -> LoginPresenter {
///         LoginPresenter(delegate: view, router: makeRouter(view: view))
///     }
///     static func makeInteractor(presenter: LoginPresenter) -> LoginInteractor {
///         LoginInteractor(delegate: presenter)
///     }
///     static func makeRouter(view: LoginViewController) -> LoginRouter {
///         LoginRouter(view: view)
///     }
/// }
/// let vc = LoginFactory.makeModule()
/// ```
protocol ViperModuleFactory {
    associatedtype View: BaseViewControllerProtocol
    associatedtype Presenter: BasePresenterProtocol
    associatedtype Interactor: BaseInteractorProtocol
    associatedtype Router: BaseRouterProtocol

    static func makeView() -> View
    static func makePresenter(view: View, router: Router) -> Presenter
    static func makeInteractor(presenter: Presenter) -> Interactor
    static func makeRouter(view: View) -> Router
}

extension ViperModuleFactory where View: BaseViewControllerProtocol,
                                   Presenter: BasePresenterProtocol,
                                   Interactor: BaseInteractorProtocol {
    /// Creates and wires up all VIPER components, returning the entry-point view.
    static func makeModule() -> View {
        let view = makeView()
        let router = makeRouter(view: view)
        let presenter = makePresenter(view: view, router: router)
        let interactor = makeInteractor(presenter: presenter)
        presenter.setUp(interactor: interactor)
        view.setUp(presenter: presenter)
        return view
    }
}
