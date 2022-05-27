# BitCoinz
A demo app to showcase testable, modern iOS development with SwiftUI and Combine on MVP+C architecture. Basically fetches data from Coins API. Applies sorting. On detail, shows details.

Tech Stack: Swift, SwiftUI, Combine 
Architecture: VIVM (View - Interactor - ViewModel + Coordinators)

Unit tests are implemented for successful and failing cases, UITests also implemented.

** Note: I'm using this app to test some different architecture questions when it comes to SwiftUI, things are reworked frequently **

## SwiftUI V-I-VM
TL:DR; Application use case logic and presentation logic occur in the interactor. The interactor outputs information to light weight view model. The view observes the view model and sends signals to the interactor when actions occur.

![Diagram showing organisation of MVP+C components](/VIVM.png?raw=true)

This design pattern is closely related to MVVM (model, view, view model - common for SwiftUI or reactive apps), but the role of the view model is split. Application logic is implemented in the interactor- when a user interacts with the view, the interactor knows how to handle those interactions. The interactor outputs formatted data to a simple view model (a struct), which is observed by the view.

This enables unidirectional-like data flow, a good separation of concerns, and facilitates reactive, declarative views which are decoupled from the business and application logic.

A fully reactive paradigm would see the interactor subscribe to actions in the view, and expose publishers which are then connected to the view model, I'm still trying to figure that one out...

### Isn't this VIP or MVP? Some theory...
I love VIP (view, interactor, presenter) and MVP (model, view, presenter), but a presenter knows about the view and how to change it. It's role is to *reach out* and manipulate the view when state changes. SwiftUI is fundementally reactive and declarative, meaning the view should simply reflect the state of some model, so a presenter is never going to be appropriate.

This doesn't mean we have to give up on well segmented code, or even the readability that uni-directional data flow paradigms like VIP give us (where data always flows from view to interactor to presenter to view). 

In this VIVM pattern, signals go from the view to the interactor, and the output of the interactor is the view model, and the view model drives the view- this avoids two way bindings (which can make it hard to predict the consequences of a runtime action), and side steps issues of any retain cycles which VIP can introduce (since the view model does not know anything about the interactor or the view.)

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
- [x] Add factory tests
- [ ] Add image caching with persistence
- [ ] Attempt to simplify ViewModel API using keypaths/property wrappers
- [ ] Write tests for coordinator, network layer, provider and store
- [x] Separate use case (application business rules) from interface adapters (presenters)
- [ ] Run mock server to facilitate full UI Testing
- [ ] Add favorites feature with local persistence
- [ ] Add image caching with local persistence
- [ ] Add filtering by favorite
