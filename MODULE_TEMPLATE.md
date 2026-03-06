# VIPER Module Template

Use this checklist and copy-paste snippets when adding a new VIPER module.

---

## Quick checklist

- [ ] Create folder `VIPER/Module/<Name>/Presenter/`
- [ ] Create folder `VIPER/Module/<Name>/Interactor/`
- [ ] Create folder `VIPER/Module/<Name>/Router/`
- [ ] Create folder `VIPER/Module/<Name>/View/`
- [ ] Create test folder `VIPERTests/Module/<Name>/Presenter/`
- [ ] Create test folder `VIPERTests/Module/<Name>/Interactor/`
- [ ] Create test folder `VIPERTests/Module/<Name>/Mock/`
- [ ] Register every `.swift` file in `VIPER.xcodeproj/project.pbxproj`

---

## Minimal module files

Replace every occurrence of `<Name>` with your module name (e.g. `Login`).

### `<Name>Presenter.swift`

```swift
import Foundation

protocol <Name>PresenterProtocol: BasePresenterProtocol {
    // Add presenter methods here
}

final class <Name>Presenter: BasePresenter<<Name>PresenterDelegate, <Name>RouterProtocol, <Name>InteractorProtocol> {
    override func setUp() {
        // Called from viewDidLoad – trigger initial data load here
        self.interactor?.fetchData()
    }
}

protocol <Name>PresenterDelegate: BasePresenterDelegate, ViewLoadable {
    // Add delegate methods here
}

extension <Name>Presenter: <Name>PresenterProtocol {
    // Implement PresenterProtocol methods here
}

extension <Name>Presenter: <Name>InteractorDelegate {
    func fetchDataStarted() { self.delegate?.showLoading() }
    func didFetchData()     { self.delegate?.hideLoading() }
}
```

### `<Name>Interactor.swift`

```swift
import Foundation

protocol <Name>InteractorProtocol: BaseInteractorProtocol {
    func fetchData()
}

final class <Name>Interactor: BaseInteractor<<Name>InteractorDelegate> {}

protocol <Name>InteractorDelegate: BaseInteractorDelegate {
    func fetchDataStarted()
    func didFetchData()
}

extension <Name>Interactor: <Name>InteractorProtocol {
    func fetchData() {
        self.delegate?.fetchDataStarted()
        // … perform async work …
        self.delegate?.didFetchData()
    }
}
```

### `<Name>Router.swift`

```swift
import UIKit

protocol <Name>RouterProtocol: BaseRouterProtocol {
    // Add navigation methods here
}

final class <Name>Router: BaseRouter<<Name>ViewController> {}

extension <Name>Router: <Name>RouterProtocol {
    // Implement navigation methods using the built-in NavigationHelpers:
    //   push(_:), pop(), present(_:), dismiss()
}
```

### Module factory (replaces the `createModule` boilerplate)

```swift
import UIKit

enum <Name>Factory: ViperModuleFactory {
    static func makeView() -> <Name>ViewController { <Name>ViewController() }

    static func makeRouter(view: <Name>ViewController) -> <Name>Router {
        <Name>Router(view: view)
    }

    static func makePresenter(view: <Name>ViewController, router: <Name>Router) -> <Name>Presenter {
        <Name>Presenter(delegate: view, router: router)
    }

    static func makeInteractor(presenter: <Name>Presenter) -> <Name>Interactor {
        <Name>Interactor(delegate: presenter)
    }
}

// Usage: let vc = <Name>Factory.makeModule()
```

### `<Name>ViewController.swift`

```swift
import UIKit

final class <Name>ViewController: BaseViewController<<Name>PresenterProtocol> {
    override func viewDidLoad() {
        super.viewDidLoad()   // triggers presenter.viewDidLoad() → setUp()
    }
}

extension <Name>ViewController: <Name>PresenterDelegate {
    // Implement delegate methods here
}
```

---

## Test mock files

### `<Name>InteractorMock.swift`

```swift
@testable import VIPER

final class <Name>InteractorMock: MockBase, <Name>InteractorProtocol {
    func fetchData() { record(#function) }
}
```

### `<Name>RouterMock.swift`

```swift
@testable import VIPER

final class <Name>RouterMock: MockBase, <Name>RouterProtocol {
    // Implement RouterProtocol navigation methods and call record(#function)
}
```

### `<Name>PresenterDelegateMock.swift`

```swift
@testable import VIPER

final class <Name>PresenterDelegateMock: MockBase, <Name>PresenterDelegate {
    func showLoading() { record(#function) }
    func hideLoading() { record(#function) }
}
```

### `<Name>PresenterTests.swift`

```swift
import XCTest
@testable import VIPER

final class <Name>PresenterTests: XCTestCase {
    var sut: <Name>Presenter!
    var delegate: <Name>PresenterDelegateMock!
    var interactor: <Name>InteractorMock!
    var router: <Name>RouterMock!

    override func setUp() {
        delegate  = <Name>PresenterDelegateMock()
        router    = <Name>RouterMock()
        interactor = <Name>InteractorMock()
        sut = <Name>Presenter(delegate: delegate, router: router)
        sut.setUp(interactor: interactor)
    }

    func test_setUp_callsFetchData() {
        sut.setUp()
        XCTAssertMethodsCalled(interactor, methods: "fetchData()")
    }
}
```

---

## Available base utilities

| Utility | File | Description |
|---------|------|-------------|
| `ViperModuleFactory` | `Base/ModuleFactory/ViperModuleFactory.swift` | Generic factory protocol — wire once, reuse everywhere |
| `ViperDependencyContainer` | `Base/ModuleFactory/ModuleFactory+DI.swift` | Simple shared-instance DI container |
| `AlertPresentable` | `Base/Presentation/AlertPresentable.swift` | Standard alert dialog helper |
| `ToastPresentable` | `Base/Presentation/ToastPresentable.swift` | Non-intrusive toast notification |
| `LoadablePresenterDelegate` | `Base/VIPER/Presenter/LoadablePresenter.swift` | Typed loading-state delegate |
| `NavigationHelpers` | `Base/VIPER/Router/NavigationHelpers.swift` | `push`, `pop`, `present`, `dismiss` on every router |
| `MockBase` | `VIPERTests/Helpers/MockBase.swift` | Auto-tracking base for test mocks |
| `PropertyTracker<T>` | `VIPERTests/Helpers/PropertyTracker.swift` | Record property assignment history |
| `XCTestAssertHelpers` | `VIPERTests/Helpers/XCTestAssertHelpers.swift` | `XCTAssertEventually`, `XCTAssertMethodsCalled` |
| `AsyncTestHelpers` | `VIPERTests/Helpers/AsyncTestHelpers.swift` | `waitForCondition`, `expectCompletion` |
