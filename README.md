![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg)
# BASE VIPER → MVVM

MVVM architecture base for iOS or tvOS using SwiftUI and Combine.

## Architecture

This project uses **MVVM** (Model–View–ViewModel) with SwiftUI and the Coordinator pattern for navigation.

### Structure

```
VIPER/
├── Base/
│   ├── MVVM/
│   │   ├── BaseViewModel.swift    # ObservableObject base class
│   │   ├── Coordinator.swift      # Navigation protocol
│   │   └── Service.swift          # Business logic protocol
│   └── ViewLoadable/
│       └── ViewLoadable.swift     # Loading state protocol
└── Module/
    └── Example/
        ├── Model/
        │   └── ExampleModel.swift
        ├── View/
        │   └── ExampleView.swift  (SwiftUI)
        ├── ViewModel/
        │   └── ExampleViewModel.swift
        ├── Service/
        │   └── ExampleService.swift
        └── Coordinator/
            └── ExampleCoordinator.swift
```

### Patterns

- **ViewModel** – extends `BaseViewModel` (`ObservableObject`), uses `@Published` for reactive state
- **View** – SwiftUI `View` using `@StateObject` / `@ObservedObject`
- **Service** – business logic, async data fetching
- **Coordinator** – navigation, owns and creates the ViewModel

## How to use

1. Look at the `Example` module for a full implementation
2. Extend `BaseViewModel` for new ViewModels
3. Conform to `Coordinator` for navigation
4. Conform to `Service` for business logic

## Author
Felipe Remigio

*I will appreciate your contribution if you have any idea to improve this*

## License
*See the LICENSE file for more info*







