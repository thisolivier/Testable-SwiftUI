# BitCoinz
A demo app to showcase testable, modern iOS development with SwiftUI and Combine on MVVM-C architecture.

Tech Stack: Swift, SwiftUI, Combine 
Architecture: MVVM+C. It is a combination of the Model-View-ViewModel architecture, plus the Coordinator pattern. A coordinator is responsible for handling a group of pages which make up a feature, including passing shared dependencies between them.

Basically fetches data from Coins API. Applies sorting. On detail, shows details.

Unit tests are implemented for successful and failing cases.

## Roadmap
- [x] Review existing code and fix glaring obvious issues
- [x] Test all view models
- [ ] Add UITests
- [ ] Use Jordan Morgan's wrapper design to decouple VM implementations from UI
- [ ] Separate use case (application business rules) from interface adapters (presenters)
- [ ] Add favorites feature with local persistence
- [ ] Add image caching with local persistence
- [ ] Add filtering by favorite
