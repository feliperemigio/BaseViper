![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
# BASE VIPER  

VIPER architecture base for iOS or tvOS

## How to use

1. Look Example folder
2. See [MODULE_TEMPLATE.md](MODULE_TEMPLATE.md) for copy-paste snippets when creating a new module

## Creating a new module

The quickest way to add a module is to conform to `ViperModuleFactory`, which handles
all component wiring automatically:

```swift
enum LoginFactory: ViperModuleFactory {
    static func makeView()    -> LoginViewController { LoginViewController() }
    static func makeRouter(view: LoginViewController) -> LoginRouter { LoginRouter(view: view) }
    static func makePresenter(view: LoginViewController, router: LoginRouter) -> LoginPresenter {
        LoginPresenter(delegate: view, router: router)
    }
    static func makeInteractor(presenter: LoginPresenter) -> LoginInteractor {
        LoginInteractor(delegate: presenter)
    }
}

// One line to create and wire the whole module:
let vc = LoginFactory.makeModule()
```

See [MODULE_TEMPLATE.md](MODULE_TEMPLATE.md) for the full template with presenter, interactor,
router, view, and test mocks.

## Available utilities

| Utility | Description |
|---------|-------------|
| `ViperModuleFactory` | Generic factory protocol — wire once, reuse everywhere |
| `ViperDependencyContainer` | Simple shared-instance DI container |
| `AlertPresentable` | Standard alert dialog helper for view controllers |
| `ToastPresentable` | Non-intrusive toast notification for view controllers |
| `LoadablePresenterDelegate` | Typed loading-state delegate |
| `NavigationHelpers` | `push`, `pop`, `present`, `dismiss` on every router |
| `MockBase` | Auto call-tracking base class for test mocks |
| `PropertyTracker<T>` | Records property assignment history in tests |
| `XCTestAssertHelpers` | `XCTAssertEventually`, `XCTAssertMethodsCalled` |
| `AsyncTestHelpers` | `waitForCondition`, `expectCompletion` |

## Author
Felipe Remigio

*I will appreciate your contribution if you have any idea to improve this*  

## License
*See the LICENSE file for more info*







