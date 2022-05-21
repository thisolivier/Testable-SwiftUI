# BitCoinz
A demo app to showcase testable, modern iOS development with SwiftUI and Combine on MVVM-C architecture. Basically fetches data from Coins API. Applies sorting. On detail, shows details.

Tech Stack: Swift, SwiftUI, Combine 
Architecture: MVVM+C (Model-View-ViewModel + Coordinator)

Unit tests are implemented for successful and failing cases, UITests also implemented.

** Note: I'm using this app to test some different architecture questions when it comes to SwiftUI, things are reworked frequently **

## Testable MVVM
Two way binding between a view model and the view. Feature level application logic, and Presentation logic lives in the view model. Logic not specific to visible feature is extracted into providers/store objects.
For complex views with many dependencies, a factory object is provided. Factories should be stateless and provide a static constructor which will attempt to provide default dependencies. Factories should allow for specific dependencies to be injected.
Views and ViewModels should *strongly avoid* refrencing concrete implementation types and shared instances directly. It's fine to use a shared instance (e.g. a shared environment variable), but leave it to the factory or other caller to inject the refrence.

## Coordinators
Coordinators are responsible for the flow of different views which, together, make up a feature. They are also responsible for holding any state which must be shared between the views which make up a feature, and making sure its passed around as appropriate.

A coordinator should only need one public methos, ´start()´ method to be used. Each view it provides which can route the app should expect a RoutingDelegate, which any coordinator showing that view can conform to. This allows different coordinators to use the same views, and keeps views agnostic about how routing is being handled.

## Roadmap
- [x] Review existing code and fix glaring obvious issues
- [x] Test all view models
- [x] Add UITests
- [x] Re-work network layer implementation and dependency injection pattern
- [ ] Use Jordan Morgan's wrapper design to decouple VM implementations from UI
- [ ] Write tests for coordinator, network layer, provider and store
- [ ] Separate use case (application business rules) from interface adapters (presenters)
- [ ] Run mock server to facilitate full UI Testing
- [ ] Add favorites feature with local persistence
- [ ] Add image caching with local persistence
- [ ] Add filtering by favorite
