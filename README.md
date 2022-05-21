# BitCoinz
A demo app to showcase testable, modern iOS development with SwiftUI and Combine on MVP+C architecture. Basically fetches data from Coins API. Applies sorting. On detail, shows details.

Tech Stack: Swift, SwiftUI, Combine 
Architecture: MVP+C (Model-View-Presenter + Coordinator)

Unit tests are implemented for successful and failing cases, UITests also implemented.

** Note: I'm using this app to test some different architecture questions when it comes to SwiftUI, things are reworked frequently **

## SwiftUI MVP
TL:DR; Application use case logic, and presentation logic occur in the Presenter. The presenter outputs information to a light weight view model holder. The view observes the view model holder and sends signals to the presenter when interactions occur.

![Diagram showing organisation of MVP+C components](/MVP+C.png?raw=true)

You might notice that my implementation of MVP has a View Model, and this is... not normal. I wanted to move away from MVVM since the View Model is responsible for holding a large interface of properties for the view to read, managing model dependencies, and responding to interactions from the view, and this feels like somthing of a kitchen sink.

Here I give the presenter the role of the receiver for view actions (as in traditional MVP), but instead of the presenter directly manipulating the view (which would violate declarative layout), it maniplates a ViewModel. The view observes the ViewModel.

This enables unidirectional-like data flow, a good separation of concerns, and facilitates reactive, declarative views. 

A fully reactive paradigm would see the Presenter subscribe to actions in the view, and expose publishers which are then connected to the view model, I'm still trying to figure that one out... I'm also pretty sure this is closer to a VIP design than MVP, maybe VIVM?

## Factories
For complex views with many dependencies, a factory object is provided. Factories should be stateless and provide a static constructor which will attempt to provide default dependencies. Factories should allow for specific dependencies to be injected.

Views and Presenters should *strongly avoid* refrencing concrete implementation types and shared instances directly. It's fine to use a shared instance (e.g. a shared environment variable), but leave it to the factory or other caller to inject the refrence.

## Coordinators
Coordinators are responsible for the flow of different views which, together, make up a feature. They are also responsible for holding any state which must be shared between the views which make up a feature, and making sure its passed around as appropriate.

A coordinator should only need one public methos, ´start()´ method to be used. Each view it provides which can route the app should expect a RoutingDelegate, which any coordinator showing that view can conform to. This allows different coordinators to use the same views, and keeps views agnostic about how routing is being handled.

## Roadmap
- [x] Review existing code and fix glaring obvious issues
- [x] Test all view models
- [x] Add UITests
- [x] Re-work network layer implementation and dependency injection pattern
- [x] Use Jordan Morgan's wrapper design to decouple VM implementations from UI
- [ ] Add image caching with persistence
- [ ] Write tests for coordinator, network layer, provider and store
- [x]* Separate use case (application business rules) from interface adapters (presenters)
- [ ] Run mock server to facilitate full UI Testing
- [ ] Add favorites feature with local persistence
- [ ] Add image caching with local persistence
- [ ] Add filtering by favorite
