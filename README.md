
# Template iOS App using Clean Architecture and MVVM

iOS Project implemented with Clean Layered Architecture and MVVM. (Can be used as Template project by replacing item name “Movie”). **More information in medium post**: <a href="https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3">Medium Post about Clean Architecture + MVVM</a>


![Alt text](README_FILES/CleanArchitecture+MVVM.png?raw=true "Clean Architecture Layers")

## Layers
* **Domain Layer** = Entities + Use Cases + Repositories Interfaces
* **Data Repositories Layer** = Repositories Implementations + API (Network) + Persistence DB
* **Presentation Layer (MVVM)** = ViewModels + Views

### Dependency Direction
![Alt text](README_FILES/CleanArchitectureDependencies.png?raw=true "Modules Dependencies")

**Note:** **Domain Layer** should not include anything from other layers(e.g Presentation — UIKit or SwiftUI or Data Layer — Mapping Codable)

## Architecture concepts used here
* Clean Architecture https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html
* Advanced iOS App Architecture https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture
* [MVVM](ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList) 
* Data Binding using [Observable](ExampleMVVM/Presentation/Utils/Observable.swift) without 3rd party libraries 
* [Dependency Injection](ExampleMVVM/Application/DIContainer/AppDIContainer.swift)
* [Flow Coordinator](ExampleMVVM/Presentation/MoviesScene/Flows/MoviesSearchFlowCoordinator.swift)
* [Data Transfer Object (DTO)](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Data/Network/DataMapping/MoviesResponseDTO%2BMapping.swift)
* [Response Data Caching](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/master/ExampleMVVM/Data/Repositories/DefaultMoviesRepository.swift)
* [ViewController Lifecycle Behavior](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/3c47e8a4b9ae5dfce36f746242d1f40b6829079d/ExampleMVVM/Presentation/Utils/Extensions/UIViewController%2BAddBehaviors.swift#L7)
* [SwiftUI and UIKit view](ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList/View/SwiftUI/MoviesQueryListView.swift) implementations by reusing same [ViewModel](ExampleMVVM/Presentation/MoviesScene/MoviesQueriesList/ViewModel/MoviesQueryListViewModel.swift) (at least Xcode 11 required)
* Error handling examples: in [ViewModel](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/201de7759e2d5634e3bb4b5ad524c4242c62b306/ExampleMVVM/Presentation/MoviesScene/MoviesList/ViewModel/MoviesListViewModel.swift#L116), in [Networking](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/blob/201de7759e2d5634e3bb4b5ad524c4242c62b306/ExampleMVVM/Infrastructure/Network/NetworkService.swift#L84)
* CI Pipeline ([Travis CI + Fastlane](.travis.yml))
 
## Includes
* Pagination
* Unit Tests for Use Cases(Domain Layer), ViewModels(Presentation Layer), NetworkService(Infrastructure Layer)
* Dark Mode
* Size Classes and UIStackView in Detail view
* SwiftUI example, demostration that presentation layer does not change, only UI (at least Xcode 11 required)

## Networking
If you would like to reuse Networking from this example project as repository I made it availabe [here](https://github.com/kudoleh/SENetworking)

## Views in Code vs Storyboard
This repository uses Storyboards (except one view written in SwiftUI). There is another similar repository but instead of using Storyboards, all Views are written in Code. 
It also uses UITableViewDiffableDataSource:
[iOS-Clean-Architecture-MVVM-Views-In-Code](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM-Views-In-Code)

## How to use app
To search a movie, write a name of a movie inside searchbar and hit search button. There are two network calls: request movies and request poster images. Every successful search query is stored persistently.


https://user-images.githubusercontent.com/6785311/236615779-153ef846-ae0b-4ce8-908a-57fca7158b9d.mp4


## Requirements
* Xcode Version 11.2.1+  Swift 5.0+

## Sign in with Apple Setup

This project includes Sign in with Apple authentication. To use this feature:

### 1. Enable Sign in with Apple Capability
- Open the project in Xcode
- Select the `ExampleMVVM` target
- Go to "Signing & Capabilities"
- Click "+ Capability" and add "Sign in with Apple"

### 2. Configure Apple Developer Account
- Ensure your app's bundle identifier is registered in your Apple Developer account
- Enable "Sign in with Apple" capability for your App ID in the Apple Developer portal
- The feature works in both development and production builds

### 3. Team ID and Bundle Identifier
- Update the bundle identifier and team ID in the Xcode project settings
- The default service name for Keychain storage is derived from the bundle identifier

### Architecture
The authentication implementation follows Clean Architecture:
- **Domain Layer**: `UserProfile` entity, `AuthRepository` and `SecureStorageRepository` protocols, and auth use cases
- **Data Layer**: `DefaultAuthRepository` with `ASAuthorizationAppleIDProvider`, `KeychainSecureStorageRepository` for secure credential storage
- **Presentation Layer**: `OnboardingViewController` with `ASAuthorizationAppleIDButton`, `OnboardingViewModel` managing auth state
- **Flow**: `HealthFlowCoordinator` checks auth state on launch and routes between onboarding and dashboard

